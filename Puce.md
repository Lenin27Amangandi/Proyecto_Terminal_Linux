```python
import tkinter as tk
from tkinter import scrolledtext
import vlc
import csv
import os
import random
from datetime import datetime
from collections import defaultdict

# ------------------ ARCHIVOS ------------------ #
ARCHIVO_CSV = "horariobot.csv"
ARCHIVO_NOTAS = "notasbot.txt"

# ------------------ ESTACIONES ------------------ #
ESTACIONES_CLIAMP = [
    {"name": "Lofi Girl (Principal)", "url": "http://lofi.stream.laut.fm/lofi"},
    {"name": "Chillhop Music", "url": "http://lofi.stream.laut.fm/lofi"},
    {"name": "Jazz Piano", "url": "http://strm112.1.fm/ajazz_mobile_mp3"},
    {"name": "Retro Wave", "url": "http://radio.plaza.one/mp3"}
]

# ------------------ VARIABLES ------------------ #
estado = "inicio"
estado_notas = False
player = None

horario_data = defaultdict(list)

orden_dias = {
    "lunes": 1,
    "martes": 2,
    "miercoles": 3,
    "miércoles": 3,
    "jueves": 4,
    "viernes": 5,
    "sabado": 6,
    "sábado": 6,
    "domingo": 7
}

# ------------------ MATRIZ HORARIO ------------------ #
def generar_matriz_horario():
    dias_ordenados = sorted(horario_data.keys(), key=lambda x: orden_dias.get(x.lower(), 99))

    horas_set = set()
    for dia in horario_data:
        for item in horario_data[dia]:
            horas_set.add(item["hora"])

    horas_ordenadas = sorted(horas_set)

    matriz = []

    encabezado = ["Hora"] + dias_ordenados
    matriz.append(encabezado)

    for hora in horas_ordenadas:
        fila = [hora]
        for dia in dias_ordenados:
            actividad = ""
            for item in horario_data[dia]:
                if item["hora"] == hora:
                    actividad = item["actividad"]
            fila.append(actividad)
        matriz.append(fila)

    return matriz


def matriz_a_texto(matriz):
    texto = ""
    for fila in matriz:
        texto += " | ".join(fila) + "\n"
    return texto

# ------------------ MÚSICA ------------------ #
def reproducir_url(url):
    global player
    if player:
        player.stop()
    instancia = vlc.Instance("--no-video")
    player = instancia.media_player_new()
    player.set_media(instancia.media_new(url))
    player.play()

# ------------------ NOTAS ------------------ #
def guardar_nota(texto):
    ahora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(ARCHIVO_NOTAS, "a", encoding="utf-8") as f:
        f.write(f"[{ahora}] {texto}\n")

# ------------------ CHATBOT ------------------ #
def responder(mensaje):
    global estado, estado_notas

    m = mensaje.lower().strip()

    # ---------------- SALIR ---------------- #
    if m == "salir":
        ventana.destroy()
        return "Cerrando bot..."

    # ---------------- PARAR MUSICA ---------------- #
    if m == "parar":
        if player:
            player.stop()
        return "⏹️ Música detenida."

    # ---------------- MUSICA ALEATORIA ---------------- #
    if m == "aleatoria":
        r = random.choice(ESTACIONES_CLIAMP)
        reproducir_url(r["url"])
        return f"🎲 Reproduciendo: {r['name']}"

    # ---------------- LISTAR MUSICA ---------------- #
    if "musica" in m:
        resp = "🎵 Estaciones CLIAMP:\n"
        for i, r in enumerate(ESTACIONES_CLIAMP):
            resp += f"{i+1}. {r['name']}\n"
        resp += "\nUsa: poner 1"
        return resp

    # ---------------- PONER MUSICA ---------------- #
    if m.startswith("poner"):
        try:
            idx = int(m.split(" ")[1]) - 1
            r = ESTACIONES_CLIAMP[idx]
            reproducir_url(r["url"])
            return f"▶️ Reproduciendo: {r['name']}"
        except:
            return "❌ Número inválido"

    # ==================================================
    # 📅 HORARIO
    # ==================================================

    if m == "horario":
        estado = "horario"
        return "📅 Modo horario activo. Ej: Lunes 9-11 Matematicas. Escribe 'fin' para guardar."

    if m == "ver horario":
        if not horario_data:
            return "⚠️ No hay horario guardado."

        matriz = generar_matriz_horario()
        texto = matriz_a_texto(matriz)

        return "📊 Tu horario:\n\n" + texto

    if estado == "horario":
        if m == "fin":
            estado = "inicio"

            with open(ARCHIVO_CSV, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow(["Día", "Hora", "Actividad"])

                for dia in sorted(horario_data.keys(), key=lambda x: orden_dias.get(x.lower(), 99)):
                    for item in horario_data[dia]:
                        writer.writerow([dia, item["hora"], item["actividad"]])

            matriz = generar_matriz_horario()
            texto = matriz_a_texto(matriz)

            return "📁 Horario guardado.\n\n📊 Así quedó:\n\n" + texto

        try:
            partes = mensaje.split(" ", 2)
            dia = partes[0].capitalize()
            hora = partes[1]
            act = partes[2]

            horario_data[dia].append({
                "hora": hora,
                "actividad": act
            })

            return f"✅ Guardado: {dia} {hora} -> {act}"

        except:
            return "❌ Usa: Lunes 9-11 Matematicas"

    # ==================================================
    # 📝 NOTAS
    # ==================================================

    if m in ["notas", "apuntes", "escribir", "escribir notas"]:
        estado_notas = True
        return "📝 Modo notas activado. Escribe tus apuntes. 'fin' para salir."

    if estado_notas:
        if m == "fin":
            estado_notas = False
            return "📁 Notas guardadas en notasbot.txt"

        guardar_nota(m)
        return "✅ Nota guardada."

    # ---------------- DEFAULT ---------------- #
    return "🤖 Comandos: horario, ver horario, notas, musica, aleatoria, parar, salir"

# ------------------ INTERFAZ ------------------ #
def enviar(event=None):
    msg = entrada.get()
    if not msg.strip():
        return

    chat.insert(tk.END, "Tú: " + msg + "\n", "user")

    res = responder(msg)

    chat.insert(tk.END, "Bot: " + res + "\n\n", "bot")

    entrada.delete(0, tk.END)
    chat.yview(tk.END)

ventana = tk.Tk()
ventana.title("StudyBot Pro CLIAMP")
ventana.geometry("520x600")
ventana.config(bg="#EDE7F6")

chat = scrolledtext.ScrolledText(
    ventana,
    font=("Segoe UI", 11),
    fg="black",
    bg="white"
)
chat.pack(padx=15, pady=15, fill=tk.BOTH, expand=True)

# Colores
chat.tag_config("user", foreground="#000000")
chat.tag_config("bot", foreground="#1A237E")

entrada = tk.Entry(ventana, font=("Segoe UI", 12))
entrada.pack(fill=tk.X, padx=15, pady=10)
entrada.bind("<Return>", enviar)

chat.insert(tk.END, "Bot: Sistema iniciado. Usa comandos: horario, ver horario, notas, musica\n\n")

ventana.mainloop()

```



'''python
import tkinter as tk
from tkinter import scrolledtext
import vlc
import csv
import os
import random
from datetime import datetime
from collections import defaultdict

# ------------------ ARCHIVOS ------------------ #
ARCHIVO_CSV = "horariobot.csv"
ARCHIVO_NOTAS = "notasbot.txt"

# ------------------ ESTACIONES ------------------ #
ESTACIONES_CLIAMP = [
    {"name": "Lofi Girl (Principal)", "url": "http://lofi.stream.laut.fm/lofi"},
    {"name": "Chillhop Music", "url": "http://icecast.unitedradio.it/Chillhop.mp3"},
    {"name": "Jazz Piano", "url": "http://strm112.1.fm/ajazz_mobile_mp3"},
    {"name": "Retro Wave", "url": "http://radio.plaza.one/mp3"}
]

# ------------------ VARIABLES ------------------ #
estado = "inicio"
estado_notas = False
player = None

horario_data = defaultdict(list)

orden_dias = {
    "lunes": 1,
    "martes": 2,
    "miercoles": 3,
    "miércoles": 3,
    "jueves": 4,
    "viernes": 5,
    "sabado": 6,
    "sábado": 6,
    "domingo": 7
}

# ------------------ MÚSICA ------------------ #
def reproducir_url(url):
    global player
    if player:
        player.stop()
    instancia = vlc.Instance("--no-video")
    player = instancia.media_player_new()
    player.set_media(instancia.media_new(url))
    player.play()

# ------------------ NOTAS ------------------ #
def guardar_nota(texto):
    ahora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(ARCHIVO_NOTAS, "a", encoding="utf-8") as f:
        f.write(f"[{ahora}] {texto}\n")

# ------------------ CHATBOT ------------------ #
def responder(mensaje):
    global estado, estado_notas

    m = mensaje.lower().strip()

    # ---------------- SALIR ---------------- #
    if m == "salir":
        ventana.destroy()
        return "Cerrando bot..."

    # ---------------- PARAR MUSICA ---------------- #
    if m == "parar":
        if player:
            player.stop()
        return "⏹️ Música detenida."

    # ---------------- MUSICA ALEATORIA ---------------- #
    if m == "aleatoria":
        r = random.choice(ESTACIONES_CLIAMP)
        reproducir_url(r["url"])
        return f"🎲 Reproduciendo: {r['name']}"

    # ---------------- LISTAR MUSICA ---------------- #
    if "musica" in m:
        resp = "🎵 Estaciones CLIAMP:\n"
        for i, r in enumerate(ESTACIONES_CLIAMP):
            resp += f"{i+1}. {r['name']}\n"
        resp += "\nUsa: poner 1"
        return resp

    # ---------------- PONER MUSICA ---------------- #
    if m.startswith("poner"):
        try:
            idx = int(m.split(" ")[1]) - 1
            r = ESTACIONES_CLIAMP[idx]
            reproducir_url(r["url"])
            return f"▶️ Reproduciendo: {r['name']}"
        except:
            return "❌ Número inválido"

    # ==================================================
    # 📅 MODO HORARIO
    # ==================================================

    if m == "horario":
        estado = "horario"
        return "📅 Modo horario activo. Ej: Lunes 9-11 Matematicas. Escribe 'fin' para guardar."

    if estado == "horario":
        if m == "fin":
            estado = "inicio"

            with open(ARCHIVO_CSV, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow(["Día", "Hora", "Actividad"])

                for dia in sorted(horario_data.keys(), key=lambda x: orden_dias.get(x.lower(), 99)):
                    for item in horario_data[dia]:
                        writer.writerow([dia, item["hora"], item["actividad"]])

            return "📁 Horario guardado y ordenado."

        try:
            partes = mensaje.split(" ", 2)
            dia = partes[0].capitalize()
            hora = partes[1]
            act = partes[2]

            horario_data[dia].append({
                "hora": hora,
                "actividad": act
            })

            return f"✅ Guardado: {dia} {hora} -> {act}"

        except:
            return "❌ Usa: Lunes 9-11 Matematicas"

    # ==================================================
    # 📝 MODO NOTAS
    # ==================================================

    if m in ["notas", "apuntes", "escribir", "escribir notas"]:
        estado_notas = True
        return "📝 Modo notas activado. Escribe tus apuntes. 'fin' para salir."

    if estado_notas:
        if m == "fin":
            estado_notas = False
            return "📁 Notas guardadas en notasbot.txt"

        guardar_nota(m)
        return "✅ Nota guardada."

    # ---------------- DEFAULT ---------------- #
    return "🤖 Comandos: horario, notas, musica, aleatoria, parar, salir"

# ------------------ INTERFAZ ------------------ #
def enviar(event=None):
    msg = entrada.get()
    if not msg.strip():
        return

    chat.insert(tk.END, "Tú: " + msg + "\n", "user")

    res = responder(msg)

    chat.insert(tk.END, "Bot: " + res + "\n\n", "bot")

    entrada.delete(0, tk.END)
    chat.yview(tk.END)

ventana = tk.Tk()
ventana.title("StudyBot Pro CLIAMP")
ventana.geometry("520x600")
ventana.config(bg="#EDE7F6")

chat = scrolledtext.ScrolledText(ventana, font=("Segoe UI", 10))
chat.pack(padx=15, pady=15, fill=tk.BOTH, expand=True)

entrada = tk.Entry(ventana, font=("Segoe UI", 12))
entrada.pack(fill=tk.X, padx=15, pady=10)
entrada.bind("<Return>", enviar)

chat.insert(tk.END, "Bot: Sistema iniciado. Usa comandos: horario, notas, musica\n\n")

ventana.mainloop()
'''
