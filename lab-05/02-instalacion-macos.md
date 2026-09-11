# 02 · Instalación de VirtualBox y Ubuntu en **macOS**

Lee primero el [README](README.md): ahí están las reglas de las capturas y de la entrega.

En Mac hay **dos rutas distintas** y no son intercambiables. Identifica la tuya antes de descargar nada:

Menú Apple  → **Acerca de esta Mac**

| Lo que dice tu Mac | Tu ruta |
|---|---|
| **Chip: Apple M1 / M2 / M3 / M4…** | [Sección A · Mac con chip Apple](#sección-a--mac-con-chip-apple-apple-silicon) |
| **Procesador: Intel Core…** | [Sección B · Mac con Intel](#sección-b--mac-con-procesador-intel) |

---

# Sección A · Mac con chip Apple (Apple Silicon)

## Lo que necesitas entender antes de empezar

Tu Mac usa arquitectura **ARM64**, no la arquitectura Intel/AMD de las PC. VirtualBox corre de forma nativa en tu equipo, pero con un límite que no se puede rodear:

> **Tu máquina virtual solo puede ejecutar sistemas operativos compilados para ARM64.** La imagen normal de Ubuntu (`amd64`) **no arranca** en tu Mac: VirtualBox no emula procesadores Intel. Necesitas la imagen **`arm64`** de Ubuntu.

Esto no es un defecto de tu equipo: es la misma barrera de arquitectura de la que hablamos en clase. Virtualizar reparte el procesador que existe; no lo transforma en otro.

---

## Paso A1 · Revisa espacio y versión

- Menú Apple  → *Acerca de esta Mac* → *Más información* → *Almacenamiento*: necesitas **40 GB libres**.
- Tu macOS debe ser **Ventura (13) o posterior**. Anota la versión: te sirve para el reporte.

En Mac no hay que activar nada en la BIOS: la virtualización viene habilitada por hardware.

---

## Paso A2 · Descarga VirtualBox para Apple Silicon

🔗 <https://www.virtualbox.org/wiki/Downloads>

En **VirtualBox platform packages**, haz clic exactamente en:

> **macOS / Apple Silicon hosts**

Se descarga un `.dmg` con nombre parecido a `VirtualBox-7.2.16-174877-macOSArm64.dmg`.

> ⚠️ **No descargues *macOS / Intel hosts***. Es el error más común en esta ruta: el instalador de Intel abrirá, pero el programa no funcionará correctamente en tu chip.

---

## Paso A3 · Instala VirtualBox

1. Doble clic en el `.dmg` y luego en **VirtualBox.pkg**.
2. Sigue el instalador y escribe tu contraseña de macOS cuando la pida.
3. Si aparece un mensaje de que **se bloqueó una extensión del sistema**, ve a **Ajustes del Sistema → Privacidad y seguridad**, baja hasta el aviso y pulsa **Permitir**. Después **reinicia la Mac**. Sin este paso VirtualBox no puede crear máquinas virtuales.
4. Abre VirtualBox desde *Aplicaciones*.

Ve al menú **VirtualBox → Acerca de VirtualBox**.

> 📸 **CAPTURA 1 de 6 — tómala ahora**
> Debe verse la ventana *Acerca de VirtualBox* con el **número de versión**, sobre tu escritorio de macOS.

---

## Paso A4 · Descarga la ISO de Ubuntu para ARM64

La página principal de Ubuntu solo ofrece la versión para Intel/AMD, así que la tuya se descarga del servidor oficial de imágenes de Canonical:

🔗 <https://cdimage.ubuntu.com/releases/26.04/release/>

En la lista de archivos busca el que se llame:

> **`ubuntu-26.04.x-desktop-arm64.iso`**

Pesa alrededor de **5 GB**. Empieza la descarga ahora y sigue leyendo.

**Cómo verificar que es la correcta**, las tres partes del nombre:
- `desktop` → con interfaz gráfica (la *live-server* es solo texto; no la uses).
- **`arm64`** → tu arquitectura. Si el nombre dice `amd64`, es la equivocada.
- `.iso` → no `.img`, no `.torrent`, no `+raspi`.

> 💡 Si en esa carpeta ves un número de versión más reciente (por ejemplo `26.04.2`), toma ese. Lo que no debe cambiar es la palabra `arm64`.

---

## Paso A5 · Crea la máquina virtual

En VirtualBox, clic en **Nueva**.

| Campo | Qué poner |
|---|---|
| Nombre | `Ubuntu-TuApellido` (ejemplo: `Ubuntu-Ramirez`) |
| Imagen ISO | El archivo `arm64` que descargaste |
| Tipo / Versión | *Linux / Ubuntu (ARM 64-bit)* |
| **Omitir instalación desatendida** | ✅ **MÁRCALA** |

> ⚠️ Marca la casilla **Omitir instalación desatendida** (*Skip Unattended Installation*). Si no, VirtualBox instala Ubuntu en automático y te pierdes el instalador, que es lo que debes documentar en la captura 3.

**Hardware:**

| Recurso | Valor |
|---|---|
| Memoria base | **4096 MB** (4 GB). Nunca salgas de la zona verde del deslizador |
| Procesadores | **2 CPU** |

**Disco:** crear disco virtual ahora, **30 GB**, sin marcar *reservar tamaño completo*.

Termina y, antes de arrancar: **Configuración → Pantalla** → *Memoria de vídeo* a **128 MB**.

Selecciona tu VM para ver el panel de resumen.

> 📸 **CAPTURA 2 de 6 — tómala ahora**
> Debe verse el nombre de tu VM, la **memoria asignada**, los **procesadores** y el **disco**.

---

## Paso A6 · Instala Ubuntu

Clic en **Iniciar**. A partir de aquí el proceso es idéntico en Mac y en PC:

1. **Idioma:** Español. **Teclado:** *Spanish (Latin American)* o *Spanish (Spain)* según tu Mac; pruébalo en el recuadro.
2. Elige **Instalar Ubuntu** (no *Probar Ubuntu*).
3. *Instalación interactiva* → *Selección predeterminada*.
4. **Borrar disco e instalar Ubuntu**.

> 😌 Ese "borrar disco" afecta **solo al disco virtual de 30 GB** que creaste. Tu macOS no se toca.

5. Crea tu usuario y contraseña. **Apúntala**: nadie puede recuperarla por ti.
6. Zona horaria: Mexico City. Confirma e **Instalar**.

Durante la barra de progreso:

> 📸 **CAPTURA 3 de 6 — tómala ahora**
> El instalador de Ubuntu en marcha, dentro de la ventana de VirtualBox.

Al terminar, reinicia. Si se queda en *Please remove the installation medium*, presiona `Enter`; si no responde, apaga la VM desde **Máquina → Apagar** y vuelve a iniciarla.

> 📸 **CAPTURA 4 de 6 — tómala ahora**
> El escritorio de Ubuntu funcionando, con tu nombre de usuario visible arriba a la derecha.

---

## Paso A7 · Verificación

**a) Guest Additions.** Con la VM encendida: **Dispositivos → Insertar imagen de CD de las Guest Additions**. En Ubuntu ARM, abre la Terminal y ejecuta:

```bash
cd /media/$USER/VBox_GAs_*/
sudo ./VBoxLinuxAdditions-arm64.run
```

Reinicia la VM al terminar. Si falla, no te detengas: no es parte de la calificación. Anótalo en tu reporte como el problema que encontraste.

**b) Actualiza y verifica.** En la Terminal:

```bash
sudo apt update && sudo apt upgrade -y
```

```bash
echo "Nombre Apellido - Grupo XX - Practica 1"
lsb_release -a
nproc && free -h
df -h /
```

Compara `nproc`, `free -h` y `df -h` con lo que asignaste en el paso A5: deben coincidir. Como dato extra para tu reporte, ejecuta `uname -m`: dirá `aarch64`, la confirmación de que tu huésped es ARM64.

> 📸 **CAPTURA 5 de 6 — tómala ahora**
> La terminal con **tu nombre** y la salida de los cuatro comandos. Sin el nombre, no cuenta.

---

## Paso A8 · Instantánea

1. **Apaga la máquina virtual.**
2. En VirtualBox, selecciona tu VM → menú de la VM (tres guiones) → **Instantáneas** → **Tomar**.
3. Nómbrala exactamente **`base-limpia`** y describe: *Ubuntu recién instalado y actualizado.*

> 📸 **CAPTURA 6 de 6 — tómala ahora**
> La lista de instantáneas mostrando `base-limpia`.

Ya terminaste. Arma tu PDF con la sección 4 del [README](README.md).

---

## Plan B para Apple Silicon: UTM

VirtualBox en Apple Silicon es reciente y en algunos Mac presenta fallas de arranque. **Solo si agotaste la sección de problemas frecuentes**, puedes hacer la práctica con **UTM**, un hipervisor de tipo 2 para Mac basado en QEMU:

🔗 <https://mac.getutm.app/> — descarga gratuita desde el sitio (en la App Store es de paga; es el mismo programa, la compra financia el proyecto).

Usa la **misma ISO `arm64`** y entrega **las mismas seis capturas** con sus equivalentes en UTM (la instantánea se hace con *Edit → Snapshot*). En la portada de tu PDF escribe **"Mac Apple Silicon — UTM"** y explica en el reporte por qué cambiaste de herramienta. Conceptualmente es idéntico: sigue siendo un hipervisor de tipo 2 sobre un sistema anfitrión.

---

## Problemas frecuentes (Apple Silicon)

| Síntoma | Causa y solución |
|---|---|
| **La VM no arranca, pantalla negra o error de arranque EFI** | Bajaste la ISO `amd64`. Verifica que el nombre diga **`arm64`**. Es la causa del 90 % de los casos. |
| **VirtualBox abre pero no crea máquinas virtuales** | Falta autorizar la extensión del sistema: *Ajustes del Sistema → Privacidad y seguridad → Permitir*, y reiniciar la Mac. |
| **En Tipo/Versión no aparece ninguna opción ARM** | Instalaste la versión para Intel. Desinstala y baja **macOS / Apple Silicon hosts**. |
| **Ubuntu instala pero va muy lento** | Sube la memoria de vídeo a 128 MB y cierra Safari y Chrome en tu macOS mientras usas la VM. |
| **Ventana diminuta que no se ajusta** | Faltan las Guest Additions (paso A7a), o simplemente usa **Ver → Escalado automático**. |

---

# Sección B · Mac con procesador Intel

Tu equipo usa la misma arquitectura que una PC, así que tu ruta es la estándar.

## Paso B1 · Descarga VirtualBox

🔗 <https://www.virtualbox.org/wiki/Downloads> → clic en:

> **macOS / Intel hosts**

Archivo parecido a `VirtualBox-7.2.16-174877-OSX.dmg`.

## Paso B2 · Instala

1. Doble clic en el `.dmg` → **VirtualBox.pkg** → sigue el instalador con tu contraseña.
2. Si macOS bloquea la extensión del sistema: **Ajustes del Sistema → Privacidad y seguridad → Permitir**, y **reinicia la Mac**.
3. Abre VirtualBox y ve a **VirtualBox → Acerca de VirtualBox**.

> 📸 **CAPTURA 1 de 6 — tómala ahora** (ventana *Acerca de*, con la versión visible)

## Paso B3 · Descarga la ISO de Ubuntu

🔗 <https://ubuntu.com/download/desktop> → la versión **LTS** que ofrezca la página.

El archivo debe terminar en **`-desktop-amd64.iso`** (unos 6 GB). `amd64` es el nombre de la arquitectura de 64 bits de Intel y AMD: es la correcta para tu Mac Intel.

> 💡 Si tu Mac tiene 8 GB de RAM, usa **Ubuntu 24.04 LTS** desde <https://ubuntu.com/download/alternative-downloads>: es más ligera. Anótalo en el reporte como decisión de dimensionamiento.

## Pasos B4 a B7 · Igual que en Windows

Desde la creación de la máquina virtual hasta la instantánea, tu proceso es **idéntico** al de la guía de Windows. Sigue estos pasos de ese documento, con las capturas 2 a 6 en los mismos puntos:

➡️ **[01-instalacion-windows.md — Paso 5: Crea la máquina virtual](01-instalacion-windows.md#paso-5--crea-la-máquina-virtual)**

Las únicas diferencias de nombre en Mac: el menú de instantáneas está en el mismo botón de tres guiones, y los atajos de captura son `Cmd + Shift + 4`.

En la portada de tu PDF escribe **"Mac Intel"**.

---

## Enlaces oficiales

- VirtualBox: <https://www.virtualbox.org/wiki/Downloads>
- Ubuntu Desktop (Mac Intel): <https://ubuntu.com/download/desktop>
- Ubuntu ARM64 (Mac con chip Apple): <https://cdimage.ubuntu.com/releases/26.04/release/>
- UTM (plan B en Apple Silicon): <https://mac.getutm.app/>
- Manual de VirtualBox: <https://www.virtualbox.org/manual>
