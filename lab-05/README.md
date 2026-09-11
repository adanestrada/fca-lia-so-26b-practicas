# Práctica 1 — Instalación de VirtualBox y Ubuntu

**Unidad de aprendizaje:** Sistemas Operativos · **Tema:** Virtualización
**Entrega:** un archivo **PDF** con las capturas de pantalla de tu proceso.

---

## Qué vas a hacer

Instalar un **hipervisor de tipo 2** (VirtualBox) en tu equipo, crear una **máquina virtual** y instalar dentro de ella **Ubuntu**. Es la aplicación práctica de lo que vimos en las dos sesiones teóricas: aquí vas a asignar tú mismo el procesador, la memoria y el disco, y vas a crear una instantánea.

Tiempo estimado: **60 a 90 minutos**, de los cuales la mayor parte es descarga. Empieza con tiempo, no la noche anterior a la entrega.

---

## 1. Elige tu guía

Antes de abrir cualquier instructivo, identifica tu equipo:

| Tu equipo | Tu guía |
|---|---|
| Windows 10 u 11 (procesador Intel o AMD) | **[01 · Instalación en Windows](01-instalacion-windows.md)** |
| Mac con chip Apple (M1, M2, M3, M4…) | **[02 · Instalación en macOS](02-instalacion-macos.md)** → sección A |
| Mac con procesador Intel | **[02 · Instalación en macOS](02-instalacion-macos.md)** → sección B |

**¿No sabes qué Mac tienes?** Menú Apple  → *Acerca de esta Mac*. Si dice **Chip: Apple M…** es Apple Silicon; si dice **Procesador: Intel…** es Intel.

> ⚠️ **Importante para Mac con chip Apple:** no puedes usar la imagen de Ubuntu normal. Necesitas la versión **ARM64**. Tu guía lo explica; si descargas la equivocada, la máquina virtual no arranca. Este es el error número uno de la práctica.

---

## 2. Requisitos mínimos de tu equipo

| Recurso | Mínimo | Recomendado |
|---|---|---|
| Memoria RAM total | 8 GB | 16 GB |
| Espacio libre en disco | 40 GB | 60 GB |
| Conexión a internet | Sí, para descargar unos 6 GB | Wi-Fi estable, no datos móviles |

Si tu equipo tiene **4 GB de RAM**, avísale al profesor **antes** de empezar: se te asignará una alternativa (trabajo de presentar a grupo un tema).

---

## 3. Las 6 capturas de pantalla obligatorias

No se piden capturas de todos los pasos: se piden **seis momentos clave**. Cada guía te indica exactamente en qué punto tomarlas, con un aviso como este:

> 📸 **CAPTURA 3 de 6 — tómala ahora**

| # | Momento | Qué debe verse |
|---|---|---|
| 1 | VirtualBox ya instalado | La ventana de *Acerca de VirtualBox*, con el número de versión |
| 2 | Antes de arrancar la máquina virtual | La configuración de la VM: nombre, memoria, procesadores y disco |
| 3 | Instalador de Ubuntu en marcha | La pantalla del instalador o su barra de progreso |
| 4 | Ubuntu ya instalado | El escritorio de Ubuntu funcionando dentro de la ventana de VirtualBox |
| 5 | Verificación por terminal | La terminal con la salida de los cuatro comandos de verificación |
| 6 | Instantánea creada | La lista de instantáneas con tu instantánea `base-limpia` |

**Reglas de las capturas:**

1. Captura de **pantalla completa**, no recortes. Debe verse la ventana de VirtualBox dentro de tu sistema (eso demuestra que corre en tu equipo).
2. No fotos con el celular. Usa `Windows + Shift + S` en Windows o `Cmd + Shift + 4` en macOS.
3. Legibles: si el texto no se lee, la captura no cuenta.
4. La **captura 5** debe incluir tu nombre impreso en la terminal. El comando está en la guía.

---

## 4. Cómo armar y entregar el PDF

1. Abre Word, Google Docs o PowerPoint.
2. **Portada** con: nombre completo, número de cuenta, grupo, fecha y el sistema que usaste (Windows / Mac Apple Silicon / Mac Intel).
3. Pega las seis capturas **en orden**, cada una con su título (`Captura 1 — VirtualBox instalado`) y **una línea tuya** explicando qué pasó ahí. Esa línea es parte de la calificación: demuestra que entendiste el paso, no solo que lo ejecutaste.
4. **Última página — Reporte breve** (media cuartilla, en tus palabras):
   - ¿Cuántos vCPU, cuánta memoria y cuánto disco le asignaste a tu VM y por qué?
   - ¿Qué problema se te presentó y cómo lo resolviste? (si todo salió bien, escríbelo también)
   - ¿Para qué te serviría la instantánea que creaste?
5. Exporta a **PDF**. Nombre del archivo: `Apellido_Nombre_Grupo_Practica1.pdf`
6. Sube el PDF en la plataforma del curso antes de la fecha límite.

---

## 5. Cómo se califica (10 puntos)

| Criterio | Puntos |
|---|---|
| Las 6 capturas, completas, legibles y en orden | 4.0 |
| Comandos de verificación correctos y con tu nombre visible (captura 5) | 1.5 |
| Instantánea creada con el nombre indicado (captura 6) | 1.0 |
| Comentario de una línea en cada captura | 1.5 |
| Reporte breve de la última página | 1.5 |
| Portada y formato del archivo (nombre y PDF) | 0.5 |

**No acredita la práctica:** entregar capturas de otro compañero, imágenes descargadas de internet, o un PDF sin el reporte final. Las capturas deben mostrar tu propio equipo y tu propio nombre de usuario.

---

## 6. Si te atoras

1. Revisa la sección **Problemas frecuentes** al final de tu guía: ahí están los cinco errores que le pasan a casi todos.
2. Si el problema persiste, escribe al profesor **adjuntando la captura del error completo**, no solo una descripción. Sin la captura no se puede diagnosticar.
3. Nunca sigas un tutorial de YouTube que te pida desactivar el antivirus o descargar VirtualBox de un sitio que no sea `virtualbox.org`.

---

## Contenido de este repositorio

```
README.md                      Este archivo: reglas, capturas y entrega
01-instalacion-windows.md      Guía para Windows 10 y 11
02-instalacion-macos.md        Guía para macOS (Apple Silicon e Intel)
```

## Enlaces oficiales (los únicos que debes usar)

- VirtualBox: <https://www.virtualbox.org/wiki/Downloads>
- Ubuntu Desktop (Intel/AMD): <https://ubuntu.com/download/desktop>
- Ubuntu para ARM64 (Mac con chip Apple): <https://cdimage.ubuntu.com/releases/26.04/release/>
- Manual de VirtualBox: <https://www.virtualbox.org/manual>
