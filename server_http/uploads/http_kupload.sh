#!/bin/bash

N="\e[38;2;100;102;109m"
R="\e[38;2;245;11;132m"
O="\e[38;2;255;112;0m"
W="\e[0m"

c=$O

A="${N}[${c}*${N}]$W"
T="${N}[${c}+${N}]$W"
F="${N}[${c}!${N}]$W"

type="${N}[${c} sender ${N}]$c"
script="${N}[${c} http ${N}]$c"
autor="${N}[${c} JsonSecurity ${N}]$c"

print_banner() {
    echo -e "${c}
                    ▄▄                   
      $script       ██                █▄
  ▄▄                 ██                ██
  ██ ▄█▀ ██ ██ ████▄ ██ ▄███▄ ▄▀▀█▄ ▄████
  ████   ██ ██ ██ ██ ██ ██ ██ ▄█▀██ ██ ██
 ▄██ ▀█▄▄▀██▀█▄████▀▄██▄▀███▀▄▀█▄██▄█▀███
               ██                        
    $type ▀   $autor
                               
       $A SIZE:$c $TOTAL_SIZE$W
       $A FILES:$c $TOTAL_FILES$W
       $A START:$c $START_LINE$W"
}

if [[ -z "$1" ]]; then
    echo -e "\n $F Usage:\n\t $0 http://<host_or_ip>:<port> [start_line]\n"
    echo -e " $F Example:\n\t $0 https://my-ngrok.app 5\n"
    exit 1
fi

URL="$1/api/upload"
START_LINE=${2:-1}

FILES_ARRAY=()
while IFS= read -r -d '' file; do
    # Remove the './' prefix from find output for cleaner display
    FILES_ARRAY+=("${file#./}")
done < <(find . -maxdepth 1 -type f -print0 | sort -z)

TOTAL_FILES=${#FILES_ARRAY[@]}

if [[ $TOTAL_FILES -eq 0 ]]; then
    echo -e "\n $F No files found in the current directory.\n"
    exit 1
fi

# Calculate size only for files (avoids 'Argument list too long' and ignores folders)
TOTAL_SIZE=$(find . -maxdepth 1 -type f -exec du -ch {} + | grep total | tail -n 1 | awk '{print $1}')

clear
print_banner
echo -e "\n $T Starting upload process...\n"

START_INDEX=$((START_LINE - 1))

for (( i=START_INDEX; i<TOTAL_FILES; i++ )); do
    FILE="${FILES_ARRAY[$i]}"
    CURRENT_LINE=$((i + 1))

    # Shows progress: [FILE 5/100] filename.mp4
    echo -e "$c  FILE ${N}[${c}${CURRENT_LINE}${N}/${c}${TOTAL_FILES}${N}]$W $FILE"

    # Important: In your Spring Boot controller, the parameter was "file", 
    # so I changed "archivo=@" to "file=@" to match your backend.
    status_code=$(curl -s -o /dev/null -w "%{http_code}" -k -X POST "$URL" -F "file=@$FILE")

    if [[ "$status_code" -ne 200 ]]; then
        echo -e "\n $A Error on line $CURRENT_LINE: HTTP $status_code"
        echo -e " $F Upload stopped. To resume, run:"
        echo -e " $W $0 \"$URL\" $CURRENT_LINE\n"
        exit 1
    fi
done

echo -e "\n $T All files finished successfully!\n"
