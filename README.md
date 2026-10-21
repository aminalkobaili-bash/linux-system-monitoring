# Linux System Monitoring

**Задача:** собрать метрики Linux-хоста стандартным `node_exporter` и собственным Bash-экспортером, визуализировать их в Grafana и проверить под нагрузкой (CPU, RAM, диск, сеть). Плюс набор Bash-утилит: сбор системной информации, анализ файловой системы, генерация и разбор логов nginx.

**Стек:** Bash, awk, coreutils / findutils, nginx, Prometheus, node_exporter, Grafana 10.4, GoAccess, stress, iperf3, Ubuntu (VM)

## Как работает

```
node_exporter ─────────────────────────────── :9100/metrics ──┐  job "node"
                                                               ├──► Prometheus :9090 ──► Grafana :3000
metrics-exporter.sh ─► /var/www/html/metrics ─► nginx :80/metrics ┘  job "custom_node"
   (каждые 3 с: CPU, RAM, диск)
```

- `node_exporter` — стандартный экспортер. Job `node` создаётся пакетом `prometheus` в Ubuntu.
- [`metrics-exporter.sh`](scripts/metrics-exporter/metrics-exporter.sh) пишет метрики в формате Prometheus exposition в файл, nginx отдаёт его как статический `/metrics`.
- Job для своего экспортера: [`configs/prometheus/custom-exporter-job.yml`](configs/prometheus/custom-exporter-job.yml).
- Нагрузка: `stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s`, заполнение диска скриптом [`disk-filler`](scripts/disk-filler), сеть — `iperf3` между двумя VM.

## Скрипты

| Скрипт | Что делает | Ключевое | Запуск |
|---|---|---|---|
| [`metrics-exporter`](scripts/metrics-exporter/metrics-exporter.sh) | свой экспортер: `custom_cpu_usage` (%), `custom_memory_used` / `custom_memory_total` (MB), `custom_disk_free` (KB) раз в 3 с | `/proc/stat`, `free`, `df`, exposition format | `sudo ./metrics-exporter.sh` |
| [`nginx-log-generator`](scripts/nginx-log-generator) | 5 файлов логов nginx в формате **combined**, по 100–1000 записей: случайные IP, методы, URL, 10 кодов ответа, User-Agent | `$RANDOM`, массивы, `date -d` | `./main.sh` |
| [`nginx-log-analyzer`](scripts/nginx-log-analyzer/main.sh) | разбор логов: 1 — сортировка по коду ответа, 2 — уникальные IP, 3 — запросы 4xx/5xx, 4 — уникальные IP с ошибками | `awk '$9 >= 400 && $9 < 600'`, `sort \| uniq` | `./main.sh 3` |
| [`sysinfo`](scripts/sysinfo) | hostname, TZ, OS, uptime, IP / маска / шлюз, RAM из `/proc/meminfo`, диск из `df`; цвета колонок из [`config.conf`](scripts/sysinfo/config.conf) с дефолтами и валидацией. `sysinfo-save.sh` дополнительно сохраняет вывод в `DD_MM_YY_HH_MM_SS.status` | модули через `source`, ANSI-цвета, конфиг | `./main.sh`, `./sysinfo-save.sh` |
| [`dir-analyzer`](scripts/dir-analyzer) | анализ каталога: число папок и файлов, файлы по типам (`.conf`, текст, исполняемые, `.log`, архивы, симлинки), топ-10 по размеру, топ-10 исполняемых с MD5, время выполнения | `find`, `du`, `file`, `md5sum` | `./main.sh /var/log/` |
| [`fs-generator`](scripts/fs-generator) | дерево папок и файлов заданного размера (до 100 KB) по шаблону имён; стоп при свободном месте < 1 GB; лог путей | `truncate`, `df --output=avail` | `./main.sh /opt/test 4 az 5 az.az 3kb` |
| [`disk-filler`](scripts/disk-filler) | нагрузочный тест диска: файлы до 100 MB в `/tmp`, `/var/tmp`, `$HOME`; стоп при < 1 GB; лог со временем начала, конца и длительностью | `dd if=/dev/zero` | `./main.sh az az.az 5Mb` |
| [`fs-cleaner`](scripts/fs-cleaner) ⚠️ | удаление созданного: 1 — по логу `disk-filler`, 2 — по интервалу времени, 3 — по маске даты в имени | `find -newermt`, `rm -rf` | `./main.sh 1` |

Скрипты подключают модули через `source ./…`, поэтому запускаются из своей папки.

**GoAccess:** [`samples/goaccess-report.html`](samples/goaccess-report.html) — HTML-отчёт по 2838 сгенерированным строкам ([пример лога](samples/access_log_sample.log)):
```bash
cat access_log_*.log > all_logs.log
goaccess all_logs.log --log-format=COMBINED -o report.html
```

## Дашборды Grafana

### 1. Собственный дашборд на node_exporter — 4 панели
Собран вручную. Запросы восстановлены по легендам на скриншотах:

| Панель | Запрос |
|---|---|
| CPU | `rate(node_cpu_seconds_total[…])` в разбивке по `mode` |
| RAM | `node_memory_MemAvailable_bytes` |
| Disk I/O | `node_disk_reads_completed_total` (см. [недочёт 2](#известные-недочёты)) |
| Disk space | `node_filesystem_avail_bytes{device="/dev/sda2"}` |

[покой](screenshots/grafana-custom/idle.jpg) · [stress](screenshots/grafana-custom/stress.jpg)

### 2. Node Exporter Full (ID 1860) — стандартный, без изменений
Импортирован по ID, не кастомизировался. Хост: 4 vCPU, 8 GiB RAM, 4 GiB swap, root FS 24 GiB.
- `stress`: CPU Busy 18.8%, Sys Load 46.5% — [скриншот](screenshots/grafana-1860/stress.jpg) (в покое: [скриншот](screenshots/grafana-1860/idle.jpg)).
- `iperf3 -c 192.168.175.130 -t 30` между двумя VM: **21.5 GB за 30 с, 6.15 Gbit/s** (receiver). На панели Network Traffic пик около 4 Gb/s — это усреднение между скрейпами. [server](screenshots/grafana-1860/iperf3-server.jpg) · [client](screenshots/grafana-1860/iperf3-client.jpg) · [Grafana](screenshots/grafana-1860/iperf3-network.jpg)

### 3. Дашборд на своём экспортере — 3 панели
`custom_cpu_usage`, `custom_memory_used`, `custom_disk_free`.
- `stress` → пик CPU 100%: [скриншот](screenshots/exporter/cpu-stress.jpg). Из-за бага исходной версии (ниже) такой пик на этом экспортере нельзя уверенно отличить от простоя.
- `disk-filler` → `custom_disk_free` падает с ~11.75 до ~10.5 млн KB (≈1.2 GB), после `fs-cleaner` возвращается: [заполнение](screenshots/exporter/disk-fill.jpg) · [очистка](screenshots/exporter/disk-cleanup.jpg).
- На этих же скриншотах видны одиночные пики CPU ровно 100% без нагрузки — это баг исходной версии экспортера (ниже).

## Исправлено после ревью: CPU 100% в простое

В исходной лабораторной был баг с парсингом `top`, из-за которого экспортер показывал 100% CPU в простое. Скрипт брал загрузку как `100 - $8` из строки `top -bn1`. При полном простое `top` печатает `0.0 ni,100.0 id` без пробела, поле `$8` становится `id,`, и `awk` считает `100 - 0 = 100`:

```
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id, ...   →  $8 = "id,"   →  CPU = 100   ✗
%Cpu(s):  1.6 us,  0.8 sy,  0.0 ni, 97.6 id, ...   →  $8 = "97.6"  →  CPU = 2.4   ✓
```

Я исправил логику сбора метрик: загрузка теперь считается по разнице счётчиков `/proc/stat` между итерациями, `(Δtotal − Δidle) / Δtotal`, без зависимости от форматирования вывода. Проверка исправленной версии (Ubuntu в WSL, 22 ядра): в простое `custom_cpu_usage 0.1`, под нагрузкой `yes` на все ядра — `100.0`. В связке с Prometheus и Grafana исправленная версия ещё не запускалась.

## Известные недочёты

1. **Экспортер:** пишет прямо в `/var/www/html/metrics`, поэтому Prometheus может прочитать файл в момент перезаписи (правильнее писать во временный файл и делать `mv`). Единицы не в именах метрик: RAM в MB, диск в KB, а по конвенции Prometheus нужно `*_bytes`. Скрипт работает как foreground-цикл без systemd-юнита.
2. **Панель Disk I/O в собственном дашборде** показывает сырой счётчик `node_disk_reads_completed_total` без `rate()` и только чтения. Поэтому заполнение диска на ней не видно (линия плоская). Нужно `rate(node_disk_writes_completed_total[1m])` и `rate(node_disk_reads_completed_total[1m])`. У CPU и RAM на этом дашборде не заданы единицы.
3. ⚠️ **`fs-cleaner` опасен без доработки.** Режимы 2 и 3 выполняют `rm -rf` по маске имени `*_DDMMYY*` во всём `$HOME`, `/tmp` и `/var/tmp` и удалят любые совпавшие файлы, не только созданные генератором. Запускать только на тестовой VM или сначала ограничить пути каталогами генератора.
4. `dir-analyzer`: в «Top 5 folders» попадает сам анализируемый каталог (`du --max-depth=1` возвращает и его). В выводе опечатки (`Totla`, `arrabged`), топ файлов подписан как «folders».
5. `fs-generator` / `disk-filler`: имя собирается только из первой и последней буквы шаблона — при 3+ символах средние не используются.
6. `nginx-log-analyzer` читает `../04/access_log_*.log` относительно текущей папки; нечисловой аргумент даёт ошибку bash вместо понятного сообщения.
7. `sysinfo` зависит от `ifconfig` (пакет net-tools), маску берёт с первого интерфейса в выводе.

## Результат
- Мониторинг хоста на Prometheus + node_exporter + Grafana: собственный дашборд и стандартный 1860, проверка под `stress`, заполнением диска и `iperf3` (6.15 Gbit/s между VM).
- Свой экспортер на Bash в формате Prometheus, отдаётся через nginx и собирается отдельным job. Баг парсинга `top` найден по графикам и исправлен.
- Разбор логов nginx через `awk`: коды ответа, уникальные IP, ошибки 4xx/5xx; тот же анализ в GoAccess.
- Bash-утилиты с валидацией аргументов, конфигом и логированием.
