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
## Mi configuracion actual

``` bash
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME="darkblood"
ZSH_THEME="gnzh"


# Ejecutar Codigo para generar una imagen random

choose_fastfetch_logo() {
    # Carpeta donde están las imágenes
    local img_dir="$HOME/.config/fastfetch/assets"

    # Elegir imagen aleatoria
    local random_img=$(ls "$img_dir" | shuf -n 1)

    local img_path="$img_dir/$random_img"
    sed -i "s#\"source\": \".*\"#\"source\": \"$img_path\"#" "$HOME/.config/fastfetch/config.jsonc"
}


#Ejecutar la aplicacion de fastfetch cada vez que se ejecuta una terminal
if [[ $- == *i* ]]; then
	choose_fastfetch_logo
	fastfetch
fi



# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
```
## Intento Numero 5 de que funcione la seleccion aleatoria

```bash
# ===== Fastfetch: Logo aleatorio automático =====
HISTORY_FILE="$HOME/.config/fastfetch/used_logos.txt"
ASSETS_DIR="$HOME/.config/fastfetch/assets"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
MAX_HISTORY=5  # Solo recordar las últimas 5 imágenes

# Crear carpetas y archivo de historial si no existen
mkdir -p "$ASSETS_DIR"
touch "$HISTORY_FILE"

# Elegir 5 imágenes aleatorias de la carpeta de imágenes
choose_fastfetch_logo() {
    # Listar todas las imágenes disponibles
    all_images=($(find "$ASSETS_DIR" -type f))

    # Si no hay imágenes, no hacer nada
    if [ ${#all_images[@]} -gt 0 ]; then
        # Leer historial de imágenes usadas
        used_images=($(cat "$HISTORY_FILE"))

        # Filtrar imágenes que no hayan sido usadas
        available_images=()
        for img in "${all_images[@]}"; do
            skip=false
            for used in "${used_images[@]}"; do
                [[ "$img" == "$used" ]] && skip=true && break
            done
            $skip || available_images+=("$img")
        done

        # Si ya se usaron todas las imágenes disponibles, reiniciar el historial
        if [ ${#available_images[@]} -eq 0 ]; then
            available_images=("${all_images[@]}")  # Usar todas las imágenes
            > "$HISTORY_FILE"  # Limpiar historial
        fi

        # Seleccionar 5 imágenes aleatorias sin repetir
        selected_images=($(shuf -e "${available_images[@]}" -n $MAX_HISTORY))

        # Guardar las imágenes seleccionadas en el historial
        echo "${selected_images[@]}" > "$HISTORY_FILE"

        # Elegir una imagen aleatoria de las seleccionadas
        random_img="${selected_images[RANDOM % ${#selected_images[@]}]}"

        # Actualizar config.jsonc con la imagen seleccionada
        if [ -f "$CONFIG_FILE" ]; then
            sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
        fi
    fi
}

# Función para limpiar el historial cuando se cierra la terminal
clear_history_on_exit() {
    if [ -f "$HISTORY_FILE" ]; then
        > "$HISTORY_FILE"  # Eliminar el contenido del archivo de historial
    fi
}

# Ejecutar la aplicación de Fastfetch cada vez que se abre una terminal
if [[ $- == *i* ]]; then
    choose_fastfetch_logo
    fastfetch
fi

# Limpiar el historial cuando la terminal se cierre (trap en zsh)
trap clear_history_on_exit EXIT

```
## Intento Numero 6 de que funcione la seleccion aleatoria

```bash
# Elegir imágenes aleatorias de la carpeta de imágenes
choose_fastfetch_logo() {
    # Definir la imagen predeterminada (la que se usará cuando el historial esté vacío)
    DEFAULT_IMAGE="$HOME/.config/fastfetch/assets/imagen_predeterminada.png"

    # Listar todas las imágenes disponibles
    all_images=($(find "$ASSETS_DIR" -type f))

    # Si no hay imágenes, no hacer nada
    if [ ${#all_images[@]} -gt 0 ]; then
        # Leer historial de imágenes usadas
        used_images=($(cat "$HISTORY_FILE"))

        # Filtrar imágenes que no hayan sido usadas
        available_images=()
        for img in "${all_images[@]}"; do
            skip=false
            for used in "${used_images[@]}"; do
                [[ "$img" == "$used" ]] && skip=true && break
            done
            $skip || available_images+=("$img")
        done

        # Si ya se usaron todas las imágenes disponibles, reiniciar el historial
        if [ ${#available_images[@]} -eq 0 ]; then
            available_images=("${all_images[@]}")  # Usar todas las imágenes
            > "$HISTORY_FILE"  # Limpiar historial
        fi

        # Si hay menos de 5 imágenes, seleccionar todas las disponibles
        if [ ${#available_images[@]} -lt $MAX_HISTORY ]; then
            selected_images=("${available_images[@]}")  # Seleccionar todas las imágenes disponibles
        else
            # Seleccionar 5 imágenes aleatorias sin repetir
            selected_images=($(shuf -e "${available_images[@]}" -n $MAX_HISTORY))
        fi

        # Guardar las imágenes seleccionadas en el historial
        echo "${selected_images[@]}" > "$HISTORY_FILE"

        # Elegir una imagen aleatoria de las seleccionadas
        random_img="${selected_images[RANDOM % ${#selected_images[@]}]}"

        # Si es el primer ciclo, asignar la imagen aleatoria
        if [ ! -f "$HISTORY_FILE" ] || [ ! -s "$HISTORY_FILE" ]; then
            random_img="$DEFAULT_IMAGE"
        fi

        # Actualizar config.jsonc con la imagen seleccionada
        if [ -f "$CONFIG_FILE" ]; then
            sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
        fi
    fi
}
```
```bash
# Elegir imágenes aleatorias de la carpeta de imágenes
choose_fastfetch_logo() {
    # Definir la imagen predeterminada (la que se usará cuando el historial esté vacío)
    DEFAULT_IMAGE="$HOME/.config/fastfetch/assets/imagen_predeterminada.png"

    # Verificar que la carpeta de imágenes existe
    if [ ! -d "$ASSETS_DIR" ]; then
        echo "Error: la carpeta de imágenes '$ASSETS_DIR' no existe."
        return
    fi

    # Listar todas las imágenes disponibles
    all_images=($(find "$ASSETS_DIR" -type f))

    # Si no hay imágenes, no hacer nada
    if [ ${#all_images[@]} -gt 0 ]; then
        # Leer historial de imágenes usadas
        if [ -f "$HISTORY_FILE" ]; then
            used_images=($(cat "$HISTORY_FILE"))
        else
            used_images=()  # Si el archivo no existe, no hay imágenes usadas
        fi

        # Filtrar imágenes que no hayan sido usadas
        available_images=()
        for img in "${all_images[@]}"; do
            skip=false
            for used in "${used_images[@]}"; do
                [[ "$img" == "$used" ]] && skip=true && break
            done
            $skip || available_images+=("$img")
        done

        # Si ya se usaron todas las imágenes disponibles, reiniciar el historial
        if [ ${#available_images[@]} -eq 0 ]; then
            available_images=("${all_images[@]}")  # Usar todas las imágenes
            > "$HISTORY_FILE"  # Limpiar historial
        fi

        # Si hay menos de 5 imágenes, seleccionar todas las disponibles
        if [ ${#available_images[@]} -lt $MAX_HISTORY ]; then
            selected_images=("${available_images[@]}")  # Seleccionar todas las imágenes disponibles
        else
            # Seleccionar 5 imágenes aleatorias sin repetir
            selected_images=($(shuf -e "${available_images[@]}" -n $MAX_HISTORY))
        fi

        # Guardar las imágenes seleccionadas en el historial
        echo "${selected_images[@]}" > "$HISTORY_FILE"

        # Elegir una imagen aleatoria de las seleccionadas
        random_img="${selected_images[RANDOM % ${#selected_images[@]}]}"

        # Si es el primer ciclo o el historial está vacío, asignar la imagen predeterminada
        if [ ${#used_images[@]} -eq 0 ] || [ ! -f "$HISTORY_FILE" ] || [ ! -s "$HISTORY_FILE" ]; then
            random_img="$DEFAULT_IMAGE"
        fi

        # Mostrar en consola para depuración
        echo "Imagen seleccionada: $random_img"

        # Actualizar config.jsonc con la imagen seleccionada
        if [ -f "$CONFIG_FILE" ]; then
            sed -i "s#\"source\": \".*\"#\"source\": \"$random_img\"#" "$CONFIG_FILE"
        else
            echo "Error: El archivo de configuración '$CONFIG_FILE' no se encuentra."
        fi
    else
        echo "Error: No se encontraron imágenes en '$ASSETS_DIR'."
    fi
}

# Ejecutar la aplicación de Fastfetch cada vez que se abre una terminal
if [[ $- == *i* ]]; then
    choose_fastfetch_logo
    fastfetch
fi
```
