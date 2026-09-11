# 01 · Instalación de VirtualBox y Ubuntu en **Windows**

Para Windows 10 y Windows 11 con procesador **Intel o AMD**.
Lee primero el [README](README.md): ahí están las reglas de las capturas y de la entrega.

> Si tu Windows corre en un procesador **ARM** (por ejemplo, Snapdragon X), avísale al profesor: tu caso necesita otra ruta.

---

## Paso 1 · Revisa que tu equipo pueda virtualizar

Antes de descargar nada, confirma dos cosas.

**a) Espacio libre.** Abre el Explorador de archivos y revisa el disco C:. Necesitas al menos **40 GB libres**.

**b) Virtualización activada.** La virtualización por hardware (Intel VT-x o AMD-V, que vimos en clase) suele venir activada, pero no siempre:

1. `Ctrl + Shift + Esc` para abrir el **Administrador de tareas**.
2. Pestaña **Rendimiento** → selecciona **CPU**.
3. Busca en la lista de la derecha el renglón **Virtualización**. Debe decir **Habilitada**.

Si dice *Deshabilitada*, hay que activarla en la BIOS/UEFI: reinicia el equipo y entra al menú de arranque (normalmente `F2`, `F10`, `Del` o `Esc`, según la marca), busca la opción `Intel Virtualization Technology`, `VT-x`, `SVM Mode` o `AMD-V`, actívala y guarda. Si no la encuentras, tómale foto al menú y consulta al profesor.

---

## Paso 2 · Descarga VirtualBox

Ve **únicamente** a la página oficial:

🔗 <https://www.virtualbox.org/wiki/Downloads>

En el bloque **VirtualBox platform packages**, haz clic en:

> **Windows hosts**

Se descarga un archivo con nombre parecido a `VirtualBox-7.2.16-174877-Win.exe` (unos 170 MB). La versión puede ser más reciente cuando lo hagas; toma siempre la que ofrezca la página.

**No necesitas** el *Extension Pack* ni el *SDK* para esta práctica. Ignóralos.

---

## Paso 3 · Instala VirtualBox

1. Doble clic en el `.exe` descargado. Acepta el aviso de Control de cuentas de usuario.
2. Deja **todas las opciones por omisión**. Siguiente, siguiente.
3. Aparecerá una advertencia de que **se reiniciará tu conexión de red** por unos segundos: es normal, VirtualBox instala un adaptador de red virtual. Acepta.
4. Si aparece un aviso sobre *Python Core / win32api*, ignóralo y continúa: no afecta esta práctica.
5. Al terminar, deja marcado *Start Oracle VirtualBox after installation* y finaliza.

Ya abierto VirtualBox, ve al menú **Ayuda → Acerca de VirtualBox**.

> 📸 **CAPTURA 1 de 6 — tómala ahora**
> Debe verse la ventana *Acerca de VirtualBox* con el **número de versión**, sobre tu escritorio de Windows.

---

## Paso 4 · Descarga la imagen ISO de Ubuntu

La ISO es el disco de instalación de Ubuntu en forma de archivo. Pesa alrededor de **6 GB**: empieza la descarga ahora y sigue leyendo mientras avanza.

🔗 <https://ubuntu.com/download/desktop>

Descarga la versión **LTS** que ofrece la página (actualmente **Ubuntu 26.04 LTS**). LTS significa soporte de largo plazo: es la que se usa en entornos reales.

**Cómo saber que es la correcta:** el nombre del archivo termina en **`-desktop-amd64.iso`**.
- `desktop` → trae interfaz gráfica (la versión *server* es solo texto, no la uses).
- `amd64` → es la arquitectura de los procesadores Intel y AMD. Es la correcta para tu equipo, aunque tu procesador sea Intel: `amd64` es el nombre histórico de la arquitectura de 64 bits, no de la marca.

> 💡 **Si tu laptop tiene solo 8 GB de RAM en total**, descarga mejor **Ubuntu 24.04 LTS** desde <https://ubuntu.com/download/alternative-downloads>. Es más ligera y correrá mejor en una máquina virtual con 4 GB asignados. Anótalo en tu reporte final: es una decisión de dimensionamiento, exactamente el tema de la sesión 2.

Guarda la ISO en una carpeta que recuerdes (por ejemplo `C:\Users\TuUsuario\Downloads`). **No la descomprimas ni la abras**: se usa tal cual.

---

## Paso 5 · Crea la máquina virtual

En VirtualBox, clic en **Nueva**.

**Pestaña de nombre y sistema:**

| Campo | Qué poner |
|---|---|
| Nombre | `Ubuntu-TuApellido` (ejemplo: `Ubuntu-Ramirez`) |
| Carpeta | Déjala como está |
| Imagen ISO | Selecciona el archivo `.iso` que descargaste |
| Tipo / Versión | Se llenan solos al elegir la ISO (*Linux / Ubuntu 64-bit*) |
| **Omitir instalación desatendida** | ✅ **MÁRCALA** |

> ⚠️ Marca sí o sí la casilla **Omitir instalación desatendida** (*Skip Unattended Installation*). Si la dejas sin marcar, VirtualBox instala Ubuntu solo, en automático, y te pierdes el instalador… que es justo lo que debes documentar en la captura 3.

**Hardware:**

| Recurso | Valor | Por qué |
|---|---|---|
| Memoria base | **4096 MB** (4 GB) | La mitad de un equipo de 8 GB. Nunca pases de la zona verde del deslizador |
| Procesadores | **2 CPU** | Suficiente para el escritorio; más no lo haría más rápido |

**Disco duro virtual:**

| Campo | Valor |
|---|---|
| Crear un disco duro virtual ahora | Sí |
| Tamaño | **30 GB** |
| Reservar tamaño completo | ❌ **Déjalo sin marcar** (aprovisionamiento ligero: el archivo crece conforme se usa) |

Clic en **Terminar**. Todavía **no la arranques**.

**Un ajuste más, para que el escritorio se vea bien:** selecciona tu VM → **Configuración → Pantalla** → sube *Memoria de vídeo* a **128 MB**. Acepta.

Ahora selecciona tu máquina virtual en la lista de la izquierda, de modo que se vea el panel de resumen con sus datos.

> 📸 **CAPTURA 2 de 6 — tómala ahora**
> Debe verse el nombre de tu VM, la **memoria asignada**, los **procesadores** y el **disco**. Es la evidencia de tu dimensionamiento.

---

## Paso 6 · Instala Ubuntu dentro de la máquina virtual

Selecciona tu VM y clic en **Iniciar**. Arranca desde la ISO.

1. Espera el logotipo de Ubuntu. Puede tardar un par de minutos.
2. **Idioma:** Español.
3. **Accesibilidad:** continuar sin cambios.
4. **Distribución del teclado:** *Spanish (Latin American)* si tu teclado tiene ñ y acentos. Pruébalo en el recuadro de prueba.
5. **Conexión a red:** deja la opción cableada (VirtualBox la provee por NAT).
6. Elige **Instalar Ubuntu** (no *Probar Ubuntu*).
7. **Tipo de instalación:** *Instalación interactiva* → *Selección predeterminada*.
8. **Instalar aplicaciones de terceros:** puedes marcarlo, no es obligatorio.
9. **Tipo de disco:** **Borrar disco e instalar Ubuntu**.

> 😌 Tranquilo: ese "borrar disco" se refiere **solo al disco virtual de 30 GB** que acabas de crear, no a tu Windows. Tu equipo real no se toca. Este es precisamente el valor del aislamiento que vimos en clase.

10. **Tu cuenta:** nombre, nombre de equipo y contraseña. **Apunta la contraseña**: la vas a necesitar en el paso 7 y nadie puede recuperarla por ti.
11. **Zona horaria:** Mexico City.
12. Revisa el resumen e **Instalar**.

Mientras corre la barra de progreso:

> 📸 **CAPTURA 3 de 6 — tómala ahora**
> La pantalla del instalador de Ubuntu en marcha, dentro de la ventana de VirtualBox.

Al terminar, pide reiniciar. Si se queda en una pantalla negra con el mensaje *Please remove the installation medium*, presiona `Enter`. Si no avanza, apaga la VM desde el menú **Máquina → Apagar** y vuelve a iniciarla: VirtualBox ya expulsó la ISO.

Inicia sesión con tu contraseña. Te recibirá el escritorio de Ubuntu.

> 📸 **CAPTURA 4 de 6 — tómala ahora**
> El escritorio de Ubuntu funcionando dentro de la ventana de VirtualBox, con tu nombre de usuario visible en la esquina superior derecha.

---

## Paso 7 · Ajustes finales y verificación

**a) Instala las Guest Additions** (las *herramientas del huésped* del glosario: ajustan la resolución y permiten copiar y pegar entre los dos sistemas).

Con la VM encendida, menú **Dispositivos → Insertar imagen de CD de las Guest Additions**. Ubuntu preguntará si quiere ejecutar el instalador: acepta, escribe tu contraseña y espera. Al terminar, reinicia la VM.

**b) Actualiza el sistema.** Abre la **Terminal** (tecla Súper y escribe `terminal`) y ejecuta:

```bash
sudo apt update && sudo apt upgrade -y
```

**c) Ejecuta la verificación.** En la misma terminal, copia estos cuatro comandos **uno por uno**. El primero imprime tu nombre en pantalla: cámbialo por tus datos reales.

```bash
echo "Nombre Apellido - Grupo XX - Practica 1"
lsb_release -a
nproc && free -h
df -h /
```

Qué te dice cada uno: `lsb_release` la versión exacta de Ubuntu, `nproc` cuántos procesadores ve el sistema huésped, `free -h` la memoria que realmente recibió y `df -h` el espacio del disco virtual. Compáralos con lo que asignaste en el paso 5: deben coincidir.

> 📸 **CAPTURA 5 de 6 — tómala ahora**
> La terminal mostrando **tu nombre** y la salida de los cuatro comandos. Sin el nombre, la captura no cuenta.

---

## Paso 8 · Crea tu instantánea

Esto cierra el tema de la sesión 2: la instantánea te permite volver a este estado limpio si más adelante rompes algo.

1. **Apaga la máquina virtual** (menú de Ubuntu → Apagar).
2. En la ventana principal de VirtualBox, selecciona tu VM.
3. Clic en el icono de menú de la VM (los tres guiones) → **Instantáneas**.
4. Clic en **Tomar** y nómbrala exactamente: **`base-limpia`**
5. En la descripción escribe: *Ubuntu recién instalado y actualizado, con Guest Additions.*
6. Acepta.

> 📸 **CAPTURA 6 de 6 — tómala ahora**
> La lista de instantáneas mostrando `base-limpia`.

Con esto terminas la parte técnica. Ahora arma tu PDF siguiendo la sección 4 del [README](README.md).

---

## Problemas frecuentes

| Síntoma | Causa y solución |
|---|---|
| **En Tipo/Versión solo aparecen opciones de 32 bits** | La virtualización está apagada en la BIOS. Regresa al paso 1b. |
| **Error `VT-x is not available (VERR_VMX_NO_VMX)` o similar** | Windows tiene el procesador tomado por Hyper-V. Abre *Activar o desactivar características de Windows* y desmarca **Hyper-V**, **Plataforma de máquina virtual** y **Plataforma del hipervisor de Windows**. Reinicia. Nota: esto desactiva WSL y algunos emuladores de Android. |
| **La VM va lentísima o se congela** | Le asignaste demasiada o muy poca memoria. Revisa que la barra de memoria esté en zona verde y cierra Chrome y Teams en tu Windows mientras trabajas en la VM. También ayuda desactivar *Núcleo aislado / Integridad de memoria* en Seguridad de Windows. |
| **Pantalla negra al arrancar la VM** | ISO incorrecta o incompleta. Verifica que el archivo termine en `-desktop-amd64.iso` y que pese los ~6 GB completos; si se cortó la descarga, bájala de nuevo. |
| **La ventana de Ubuntu queda diminuta y no se ajusta** | Faltan las Guest Additions (paso 7a). Después, menú **Ver → Escalado automático** o *Ajustar tamaño de pantalla*. |
| **No hay internet dentro de Ubuntu** | Con la VM apagada: **Configuración → Red → Adaptador 1** debe estar *Habilitado* y conectado a **NAT**. |

---

## Enlaces oficiales

- VirtualBox: <https://www.virtualbox.org/wiki/Downloads>
- Ubuntu Desktop: <https://ubuntu.com/download/desktop>
- Versiones anteriores de Ubuntu: <https://ubuntu.com/download/alternative-downloads>
- Manual de VirtualBox: <https://www.virtualbox.org/manual>
