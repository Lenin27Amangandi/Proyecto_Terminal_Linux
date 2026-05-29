#!/bin/bash

# Colores para que la terminal se vea ordenada
VERDE='\033[0;32m'
AZUL='\033[0;34m'
SIN_COLOR='\033[0m'

# Salir inmediatamente si algún comando falla
set -e

echo -e "${AZUL}[1/4] Actualizando los repositorios del sistema...${SIN_COLOR}"
apt update

echo -e "${AZUL}[2/4] Instalando herramientas de compilación (build-essential)...${SIN_COLOR}"
apt install -y build-essential

echo -e "${AZUL}[3/4] Instalando Code::Blocks IDE...${SIN_COLOR}"
apt install -y codeblocks

echo -e "${AZUL}[4/4] Instalando librerías de desarrollo OpenGL, FreeGLUT y GLEW...${SIN_COLOR}"
apt install -y freeglut3-dev libglew-dev libglu1-mesa-dev mesa-utils

echo -e "${VERDE}--------------------------------------------------${SIN_COLOR}"
echo -e "${VERDE}¡Instalación completada con éxito!${SIN_COLOR}"
echo -e "${VERDE}--------------------------------------------------${SIN_COLOR}"

# Crear una plantilla de código en la carpeta actual para tus tareas
echo -e "${AZUL}Creando plantilla de prueba 'main.cpp' en tu carpeta actual...${SIN_COLOR}"

cat << 'EOF' > main.cpp
#include <GL/glut.h>

void dibujarCubo() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    
    // Rotar un poco para el efecto 3D
    glRotatef(30, 1.0, 1.0, 0.0);
    
    glBegin(GL_QUADS);
        // Cara frontal (Rojo)
        glColor3f(1.0, 0.0, 0.0);
        glVertex3f(-0.3, -0.3,  0.3); glVertex3f( 0.3, -0.3,  0.3);
        glVertex3f( 0.3,  0.3,  0.3); glVertex3f(-0.3,  0.3,  0.3);
        // Cara trasera (Verde)
        glColor3f(0.0, 1.0, 0.0);
        glVertex3f(-0.3, -0.3, -0.3); glVertex3f(-0.3,  0.3, -0.3);
        glVertex3f( 0.3,  0.3, -0.3); glVertex3f( 0.3, -0.3, -0.3);
    glEnd();
    
    glFlush();
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(600, 600);
    glutCreateWindow("Plantilla Computación Gráfica - Zorin OS");
    glutDisplayFunc(dibujarCubo);
    glutMainLoop();
    return 0;
}
EOF

echo -e "${VERDE}Listo. Ya tienes todo instalado y tu archivo 'main.cpp' creado en este directorio.${SIN_COLOR}"




```bash
yt-mp3 () {
  tmpdir="$(mktemp -d)"

  yt-dlp -f "bestaudio" -x --audio-format mp3 \
  --cookies-from-browser brave \
  --embed-thumbnail \
  --add-metadata \
  -o "$tmpdir/%(artist|uploader)s - %(title)s [%(album|NA)s] - %(track_number|0)s.%(ext)s" \
  --restrict-filenames "$@"

  for f in "$tmpdir"/*.mp3; do
    [ -e "$f" ] || continue

    ffmpeg -i "$f" -map_metadata -1 -c copy "${f%.mp3}_clean.mp3" >/dev/null 2>&1
    mv "${f%.mp3}_clean.mp3" .

  done

  rm -rf "$tmpdir"
}
```

```bash
#!/usr/bin/env bash

echo "🔍 Configurando entorno musical en Zorin OS..."

# =========================
# 1. Dependencias básicas
# =========================

MISSING=()

command -v yt-dlp >/dev/null 2>&1 || MISSING+=("yt-dlp")
command -v ffmpeg >/dev/null 2>&1 || MISSING+=("ffmpeg")
command -v zsh >/dev/null 2>&1 || MISSING+=("zsh")
command -v git >/dev/null 2>&1 || MISSING+=("git")

if [ ${#MISSING[@]} -ne 0 ]; then
  echo "❌ Faltan paquetes: ${MISSING[*]}"
  read -p "¿Instalar? (y/n): " CONFIRM

  if [[ "$CONFIRM" == "y" ]]; then
    sudo apt update

    for pkg in "${MISSING[@]}"; do
      case $pkg in
        yt-dlp)
          sudo apt install -y yt-dlp || pip install -U yt-dlp
          ;;
        ffmpeg)
          sudo apt install -y ffmpeg
          ;;
        zsh)
          sudo apt install -y zsh
          ;;
        git)
          sudo apt install -y git
          ;;
      esac
    done
  else
    echo "🚫 Cancelado."
    exit 1
  fi
fi

# =========================
# 2. Cambiar shell a zsh
# =========================

CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "bash" ]; then
  echo "⚠️ Estás usando bash."
  read -p "¿Cambiar a zsh? (y/n): " ZSHCONFIRM

  if [[ "$ZSHCONFIRM" == "y" ]]; then
    chsh -s "$(which zsh)"
    echo "✅ Shell cambiado a zsh (reinicia sesión)."
  fi
fi

# =========================
# 3. Instalar Oh My Zsh
# =========================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Instalando Oh My Zsh..."

  RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# =========================
# 4. Instalar Powerlevel10k
# =========================

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Instalando Powerlevel10k..."

  git clone --depth=1 \
  https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# =========================
# 5. Configurar tema en .zshrc
# =========================

echo "⚙️ Configurando tema en .zshrc..."

if grep -q "ZSH_THEME=" "$HOME/.zshrc"; then
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

# =========================
# 6. Mensaje final
# =========================

echo "🎧 Todo listo."
echo "👉 Reinicia la terminal y ejecuta: p10k configure"
``
