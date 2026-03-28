#!/bin/bash

N="\e[38;2;100;102;109m"
G="\e[38;2;19;255;0m"
R="\e[38;2;245;11;132m"
Y="\e[33m"
W="\e[0m"

bol="${W}\033[1m"
bord=$N
excr=$W
c=$G
info=$R

A=" ${N}[${c}*${N}]$W"
AA=" ${N}[${c}!${N}]$W"

autor="${bol}$bord [$c Memories${bord} ]"
script="${bol}$bord [$c Client${bord} ]"

MAX_IMG_MB=1
MAX_VID_MB=1
TMP_DIR="tmp"
FAIL_DIR="error"
SERVER_URL=""                                                                                                                                                                                                                                              
START=1
COMPRESS=false
ALL_FILES=false
DIRECTORY="./"                                                                                                                                                                                                                                             

banner() {                                                                                                                                                                                                                                                     
    #Classy
    echo -e """$c
                    ▄▄
                     ██                █▄
  ▄▄                 ██                ██
  ██ ▄█▀ ██ ██ ████▄ ██ ▄███▄ ▄▀▀█▄ ▄████
  ████   ██ ██ ██ ██ ██ ██ ██ ▄█▀██ ██ ██
 ▄██ ▀█▄▄▀██▀█▄████▀▄██▄▀███▀▄▀█▄██▄█▀███
               ██
  $script$c  ▀  $autor
    $W"""
}

usage() {
    echo -e """
 [!] Usage: $G $0$R -d$W <dir>$R -h$W <host>$R -p$W <port>$R [-s <n> -a]$W\n
    -d   directory files <dir/file>
    -h   server ip
    -p   server port
    -s   start file number <n>
    -a   send ALL files (ignores extension filter, ignores directories)
    """
    exit 1
}

set_start() {
    [[ -n "$1" ]] && START="$1" || START=1
}

check_tools() {
    command -v nc >/dev/null 2>&1 || { echo -e "\n$AA Error: netcat (nc) not found.$W" >&2; exit 1; }
    command -v tar >/dev/null 2>&1 || { echo -e "\n$AA Error: tar not found.$W" >&2; exit 1; }
    # Sugerencia opcional para ver progreso:
    if ! command -v pv >/dev/null 2>&1; then
        echo -e "$A Tip: Instala 'pv' (pkg install pv) para ver una barra de progreso.$W"
    fi
}

process_files() {
    # Lógica para seleccionar todos los archivos (-a) o por extensión
    if $ALL_FILES; then
        # -type f asegura que NUNCA se incluyan carpetas
        FILES=$(find "$DIRECTORY" -maxdepth 1 -type f | sort)
    else
        FILES=$(find "$DIRECTORY" -maxdepth 1 -type f -iregex '.*\.\(pdf\|jpg\|ogg\|jpeg\|webp\|png\|mp4\|mov\|mp3\|mkv\|avi\|zip\)$' | sort)
    fi

    # Contamos ignorando líneas vacías
    TOTAL=$(echo "$FILES" | grep -v '^$' | wc -l)

    if [[ -z "$FILES" || "$TOTAL" -eq 0 ]]; then
        echo -e "\n $A Directory: $DIRECTORY\n\n $AA Files not found\n"
        exit 1
    fi

    # Calculamos el tamaño total en formato legible (Human Readable) y en Bytes puros
    SIZE_HR=$(find "$DIRECTORY" -maxdepth 1 -type f -printf '%s\n' 2>/dev/null | awk '{s+=$1} END{print s+0}' | numfmt --to=iec 2>/dev/null || echo "Unknown")

    banner

    echo -e """
       $A SIZE:$c $SIZE_HR$W
       $A FILES:$c $TOTAL$W
       $A START:$c $START$W
       $A MODE:$c $($ALL_FILES && echo 'ALL FILES' || echo 'FILTERED')$W
       $A COMPRESS:$c $($COMPRESS && echo 'ON' || echo 'OFF')$W
    """

    printf "$AA proceed... [y/n] $W"
    read -r proceed
    if [[ "$proceed" != "y" ]]; then
        echo -e "\n$AA Aborted by user.$W"
        exit 0
    fi

    echo -e "\n$A Starting...\n"

    FILES_TO_SEND=$(echo "$FILES" | tail -n +"$START")

    if [[ -z "$FILES_TO_SEND" ]]; then
        echo -e "$AA No hay archivos para enviar desde el índice $START.$W"
        exit 1
    fi

    INDEX=$((START - 1))
    while IFS= read -r FILE; do
        ((INDEX++))
        echo -e "  $N [${c}${INDEX}${N}]$W Preparando: $FILE"
    done <<< "$FILES_TO_SEND"

    echo -e "\n$A Transfiriendo archivos a $HOST:$PORT...\n"

    # TRANSFERENCIA CON O SIN PV
    if command -v pv >/dev/null 2>&1; then
        # Si tienes 'pv' instalado, verás una barra de progreso brutal
        echo "$FILES_TO_SEND" | tar cvf - -T - 2>/dev/null | pv | nc -N "$HOST" "$PORT"
    else
        # Transferencia silenciosa estándar
        echo "$FILES_TO_SEND" | tar cvf - -T - 2>/dev/null | nc -N "$HOST" "$PORT"
    fi

    echo -e "\n$A Finish\n"
}

while getopts "ach:p:d:s:" opt; do
    case $opt in
        a) ALL_FILES=true ;;
        c) COMPRESS=true ;;
        h) HOST="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        d) DIRECTORY="$OPTARG" ;;
        s) set_start "$OPTARG" ;;
        *) usage ;;
    esac
done
shift $((OPTIND -1))

[[ -z "$HOST" || -z "$PORT" ]] && usage

clear
check_tools
process_files
