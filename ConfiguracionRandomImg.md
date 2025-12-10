nano ~/.zshrc

# --- Seleccionar imagen aleatoria para Fastfetch ---
choose_fastfetch_logo() {
    # Carpeta donde están las imágenes
    local img_dir="$HOME/.config/fastfetch/assets"

    # Elegir imagen aleatoria
    local random_img=$(ls "$img_dir" | shuf -n 1)

    # Ruta completa
    local img_path="$img_dir/$random_img"

    # Reemplazar la línea del logo en config.json
    sed -i "s#\"source\": \".*\"#\"source\": \"$img_path\"#" "$HOME/.config/fastfetch/config.json"
}


if [[ $- == *i* ]]; then
    choose_fastfetch_logo
    fastfetch
fi

--- 
Primero en el zsh

# --- Función para elegir logo aleatorio ---

nano ~/.zshrc

choose_fastfetch_logo() {
    local img_dir="$HOME/.config/fastfetch/assets"
    local random_img=$(ls "$img_dir" | shuf -n 1)
    local img_path="$img_dir/$random_img"

    # Reemplaza la línea "source" en config.json
    sed -i "s#\"source\": \".*\"#\"source\": \"$img_path\"#" "$HOME/.config/fastfetch/config.json"
}

# --- Ejecutar fastfetch solo en shell interactiva ---
if [[ $- == *i* ]]; then
    choose_fastfetch_logo
    fastfetch --wrap-width $(tput cols)
fi

--- 
Errores
sed: no se puede leer /home/xander/.config/fastfetch/config.json: No existe el archivo o el directori

---

## Me Falta Testiarlos pero ya casi

#!/bin/bash

HISTORY_FILE="$HOME/.config/fastfetch/used_logos.txt"
ASSETS_DIR="$HOME/.config/fastfetch/assets"
CONFIG_FILE="$HOME/.config/fastfetch/config.json"

choose_fastfetch_logo() {
    # Crear carpeta y archivo de historial si no existen
    mkdir -p "$ASSETS_DIR"
    touch "$HISTORY_FILE"

    # Listar todas las imágenes (maneja nombres con espacios)
    mapfile -t all_images < <(find "$ASSETS_DIR" -type f)

    # Leer historial (maneja nombres con espacios)
    mapfile -t used_images < "$HISTORY_FILE"

    # Crear array de imágenes disponibles
    available_images=()
    for img in "${all_images[@]}"; do
        skip=false
        for used in "${used_images[@]}"; do
            if [[ "$img" == "$used" ]]; then
                skip=true
                break
            fi
        done
        $skip || available_images+=("$img")
    done

    # Si ya se usaron todas, reiniciar historial
    if [ ${#available_images[@]} -eq 0 ]; then
        > "$HISTORY_FILE"
        available_images=("${all_images[@]}")
    fi

    # Elegir una aleatoria
    random_img="${available_images[RANDOM % ${#available_images[@]}]}"

    # Guardar en historial
    echo "$random_img" >> "$HISTORY_FILE"

    # Reemplazar el logo en config.json
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
    fi
}
--- 
Mejorando lo anterior tonces ya toca ver
#!/bin/bash

HISTORY_FILE="$HOME/.config/fastfetch/used_logos.txt"
ASSETS_DIR="$HOME/.config/fastfetch/assets"
CONFIG_FILE="$HOME/.config/fastfetch/config.json"
MAX_IMAGES=5  # Solo usar las primeras 5 imágenes

choose_fastfetch_logo() {
    mkdir -p "$ASSETS_DIR"
    touch "$HISTORY_FILE"

    # Listar imágenes (solo las primeras MAX_IMAGES)
    mapfile -t all_images < <(find "$ASSETS_DIR" -type f | head -n $MAX_IMAGES)

    # Leer historial
    mapfile -t used_images < "$HISTORY_FILE"

    # Filtrar imágenes disponibles
    available_images=()
    for img in "${all_images[@]}"; do
        skip=false
        for used in "${used_images[@]}"; do
            if [[ "$img" == "$used" ]]; then
                skip=true
                break
            fi
        done
        $skip || available_images+=("$img")
    done

    # Si se usaron todas, reiniciar historial
    if [ ${#available_images[@]} -eq 0 ]; then
        > "$HISTORY_FILE"
        available_images=("${all_images[@]}")
    fi

    # Elegir una aleatoria
    random_img="${available_images[RANDOM % ${#available_images[@]}]}"

    # Guardar en historial
    echo "$random_img" >> "$HISTORY_FILE"

    # Actualizar config.json
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
    fi
}

---
Finalmete este puede llegar a funcionar y no darnos problemas pero me falta testiarle 
nano ~/.zshrc

# ===== Fastfetch: Logo aleatorio automático =====
HISTORY_FILE="$HOME/.config/fastfetch/used_logos.txt"
ASSETS_DIR="$HOME/.config/fastfetch/assets"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
MAX_HISTORY=5  # Solo recordar las últimas 5 imágenes

# Crear carpetas y archivo de historial si no existen
mkdir -p "$ASSETS_DIR"
touch "$HISTORY_FILE"

# Listar todas las imágenes
mapfile -t all_images < <(find "$ASSETS_DIR" -type f)

# Si no hay imágenes, no hacer nada
if [ ${#all_images[@]} -gt 0 ]; then
    # Leer historial
    mapfile -t used_images < "$HISTORY_FILE"

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

# Ejecutar Fastfetch automáticamente al abrir la terminal
fastfetch
---
# Flujo de trabajo de Fastfetch con logos aleatorios

1. **Inicio de la terminal**
   - Se abre una nueva terminal en Kitty.
   - `.zshrc` se ejecuta automáticamente.

2. **Preparación de carpetas y archivos**
   - Se asegura que exista la carpeta `~/.config/fastfetch/assets`.
   - Se crea el archivo de historial `used_logos.txt` si no existe.

3. **Listar todas las imágenes**
   - Se escanean todas las imágenes en la carpeta `assets`.
   - Resultado: `all_images = [img1, img2, img3, ..., imgN]`.

4. **Filtrar imágenes usadas**
   - Se lee el historial `used_logos.txt`.
   - Se eliminan del listado las imágenes ya usadas recientemente (`MAX_HISTORY`).
   - Resultado: `available_images = [imgX, imgY, ...]`.

5. **Reiniciar historial si se usaron todas**
   - Si `available_images` está vacío:
     - Se reinicia `used_logos.txt`.
     - `available_images = all_images`.

6. **Elegir una imagen aleatoria**
   - Se selecciona `random_img = available_images[RANDOM % #available_images]`.

7. **Actualizar historial**
   - Se agrega `random_img` al final de `used_logos.txt`.
   - Se mantiene solo las últimas `MAX_HISTORY` imágenes:
     ```
     tail -n MAX_HISTORY used_logos.txt > tmp && mv tmp used_logos.txt
     ```

8. **Actualizar config.jsonc**
   - Se reemplaza la línea de `logo.source` con la nueva imagen:
     ```
     "source": "random_img"
     ```

9. **Ejecutar Fastfetch**
   - Se ejecuta Fastfetch automáticamente mostrando:
     - Información del sistema.
     - Logo aleatorio recién seleccionado.

---

## Ejemplo de flujo visual




