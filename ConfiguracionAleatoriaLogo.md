# Configuracion Aleatoria de mi logo de imagen

``` bash
# ===== Fastfetch: Logo aleatorio automático =====
HISTORY_FILE="$HOME/.config/fastfetch/used_logos.txt"
ASSETS_DIR="$HOME/.config/fastfetch/assets"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
MAX_HISTORY=5  # Solo recordar las últimas 5 imágenes

# Crear carpetas y archivo de historial si no existen
mkdir -p "$ASSETS_DIR"
touch "$HISTORY_FILE"

# Listar todas las imágenes
all_images=($(find "$ASSETS_DIR" -type f))

# Si no hay imágenes, no hacer nada
if [ ${#all_images[@]} -gt 0 ]; then
    # Leer historial
    used_images=($(cat "$HISTORY_FILE"))

    # Filtrar imágenes disponibles
    available_images=()
    for img in "${all_images[@]}"; do
        skip=false
        for used in "${used_images[@]}"; do
            [[ "$img" == "$used" ]] && skip=true && break
        done
        $skip || available_images+=("$img")
    done

    # Si se usaron todas, reiniciar historial
    [ ${#available_images[@]} -eq 0 ] && available_images=("${all_images[@]}") && > "$HISTORY_FILE"

    # Elegir una imagen aleatoria
    random_img="${available_images[RANDOM % ${#available_images[@]}]}"

    # Guardar en historial (solo últimas MAX_HISTORY)
    echo "$random_img" >> "$HISTORY_FILE"
    tail -n $MAX_HISTORY "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

    # Actualizar config.jsonc
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
    fi
fi
```
