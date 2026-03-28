#!/bin/bash

# Comprobar si se pasó el argumento de cantidad
if [ -z "$1" ]; then
    echo "Uso: $0 <cantidad_de_archivos>"
    exit 1
fi

NUM_FILES=$1
EXTENSIONS=("mp3" "mp4" "pdf" "docx" "jpg" "mkv" "txt" "zip")

# Crear carpeta de salida para no ensuciar el directorio actual
mkdir -p test_data
cd test_data

echo "Generando $NUM_FILES archivos con peso aleatorio..."

for ((i=1; i<=NUM_FILES; i++)); do
    # Generar un nombre aleatorio de 8 caracteres
    NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
    
    # Seleccionar una extensión al azar
    EXT=${EXTENSIONS[$RANDOM % ${#EXTENSIONS[@]}]}
    
    # Definir un tamaño aleatorio entre 1MB y 10MB (ajustable)
    # count=1 quiere decir 1 unidad de bs (block size)
    SIZE=$(( (RANDOM % 10) + 1 ))
    
    # Crear el archivo con datos basura (rápido)
    dd if=/dev/urandom of="${NAME}.${EXT}" bs="${SIZE}M" count=1 conv=notrunc status=none
    
    echo "[$i/$NUM_FILES] Creado: ${NAME}.${EXT} (${SIZE}MB)"
done

echo "---"
echo "¡Listo! Se han generado $NUM_FILES archivos en la carpeta './test_data'."
