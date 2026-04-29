#!/bin/bash

# Response codes
# 200 OK
# 201 Created
# 400 Bad Request
# 401 Unauthorized
# 403 Forbidden
# 404 Not Found
# 500 Internal Server Error
# 501 Not Implemented
# 502 Bad Gateway
# 503 Service Unavailable

METHODS=(GET POST PUT PATCH DELETE)

CODES=(200 201 400 401 403 404 500 501 502 503)

AGENTS=(
"Mozilla"
"Google Chrome"
"Opera"
"Safari"
"Internet Explorer"
"Microsoft Edge"
"Crawler"
"Bot"
"Library"
"Net Tool"
)

URLS=(
"/"
"/index.html"
"/login"
"/api/data"
"/products"
"/cart"
)

generate_ip(){
echo "$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"
}

generate_logs(){

for day in {1..5}
do

LINES=$((RANDOM%900+100))

DATE=$(date -d "-$day day" +"%d/%b/%Y")

SECONDS=0

FILE="access_log_$day.log"

> "$FILE"

for ((i=0;i<LINES;i++))
do

IP=$(generate_ip)

METHOD=${METHODS[$RANDOM % ${#METHODS[@]}]}

URL=${URLS[$RANDOM % ${#URLS[@]}]}

CODE=${CODES[$RANDOM % ${#CODES[@]}]}

AGENT=${AGENTS[$RANDOM % ${#AGENTS[@]}]}

SECONDS=$((SECONDS + RANDOM%30))

TIME=$(printf "%02d:%02d:%02d" $((SECONDS/3600)) $((SECONDS/60%60)) $((SECONDS%60)))

echo "$IP - - [$DATE:$TIME +0000] \"$METHOD $URL HTTP/1.1\" $CODE 1024 \"-\" \"$AGENT\"" >> "$FILE"

done

done

}