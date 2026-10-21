#!/bin/bash

validate_input() {
    if [ "$#" -ne 1 ]
    then
        echo "Error: script must be run with one parameter."
        exit 1
    fi

    DIR="$1"

    if [[ ! -d "$DIR" ]]
    then
        echo "Error: Directory does not exist."
        exit 1
    fi

    if [[ "${DIR: -1}" != "/" ]]
    then
        echo "Error: Path must end with / ."
        exit 1
    fi
}


count_folders(){
TOTAL_FOLDERS=$(ls -lR "$DIR" 2>/dev/null | grep -c "^d")
echo "Totla number of folders (including all nested ones) = $TOTAL_FOLDERS"
echo
}

top_folders(){
echo "Top 5 folders of maximum size arrabged in descending order (path and size):"

du -h --max-depth=1 "$DIR" 2>/dev/null | sort -rh | head -n 5 | awk '{print NR " - " $2 " , " $1}'
echo
}

count_files(){
TOTAL_FILES=$(find "$DIR" -type f 2>/dev/null | wc -l)
echo "Totla number of files = $TOTAL_FILES"
echo
}

count_file_types(){
CONF_FILES=$(find "$DIR" -type f -name "*.conf" 2>/dev/null | wc -l)
TEXT_FILES=$(find "$DIR" -type f -exec file {} \; 2>/dev/null | grep -i text | wc -l)
EXEC_FILES=$(find "$DIR" -type f -executable 2>/dev/null | wc -l)
LOG_FILES=$(find "$DIR" -type f -name "*.log" 2>/dev/null | wc -l)
ARCH_FILES=$(find "$DIR" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.rar" \) 2>/dev/null | wc -l)
SYM_LINKS=$(find "$DIR" -type l 2>/dev/null | wc -l)

echo "Number of:"
echo "Configuration files (with the .conf extension) = $CONF_FILES"
echo "Text files = $TEXT_FILES"
echo "Executable files = $EXEC_FILES"
echo "log files (with the extension .log) = $LOG_FILES"
echo "Archive files = $ARCH_FILES"
echo "Symbolic links = $SYM_LINKS"
echo
}

get_file_type(){
    case "$1" in
        *.conf) echo "conf" ;;
        *.log|*.journal) echo "log" ;;
        *.txt) echo "text" ;;
        *.tar|*.gz|*.zip|*.rar|*.7z) echo "archive" ;;
        *.exe) echo "exe" ;;
        *) echo "other" ;;
    esac
}

top_files(){
echo "Top 10 folders of maximum size arrabged in descending order (path and size and type):"
counter=1

find "$DIR" -type f -exec du -h {} + 2>/dev/null \
| sort -rh \
| head -10 \
| while read size filepath
do
    FILE_TYPE=$(get_file_type "$filepath")
    echo "$counter - $filepath, $size, $FILE_TYPE"
    ((counter++))
done
echo
}

top_exec_files(){
echo "Top 10 folders of maximum size arrabged in descending order (path and size and MD5 hash of file):"
counter=1

find "$DIR" -type f -executable 2>/dev/null \
| xargs -I {} du -h "{}" 2>/dev/null \
| sort -rh \
| head -10 \
| while read size filepath
do
    HASH=$(md5sum "$filepath" | awk '{print $1}')
    echo "$counter - $filepath, $size, $HASH"
    ((counter++))
done
echo
}