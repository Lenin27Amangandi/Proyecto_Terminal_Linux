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
