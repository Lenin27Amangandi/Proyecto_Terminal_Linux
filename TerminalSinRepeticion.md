#!/bin/bash

# Configuración de rutas
LOGO_DIR="$HOME/.config/fastfetch/assets"
HIST_FILE="/tmp/fastfetch_history_$USER.txt"

# Crear archivo de historial si no existe
touch "$HIST_FILE"

# 1. Obtener todas las imágenes disponibles
ALL_LOGOS=$(find "$LOGO_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))

# 2. Filtrar cuáles NO han sido usadas (comparando con el historial)
AVAILABLE=$(grep -vxFf "$HIST_FILE" <<< "$ALL_LOGOS")

# 3. Si no quedan imágenes disponibles, reiniciar el ciclo
if [ -z "$AVAILABLE" ]; then
    > "$HIST_FILE"  # Vaciar el archivo de historial
    AVAILABLE="$ALL_LOGOS"
fi

# 4. Elegir una imagen al azar de las disponibles
RANDOM_LOGO=$(shuf -n 1 <<< "$AVAILABLE")

# 5. Guardar la elegida en el historial e imprimirla para Fastfetch
if [ -n "$RANDOM_LOGO" ]; then
    echo "$RANDOM_LOGO" >> "$HIST_FILE"
    echo "$RANDOM_LOGO"
fi
