# Práctica «Un archivo, tres mundos» · Variante **macOS** (y Linux)

> Funciona en macOS con procesador Intel o Apple Silicon (M1, M2, M3…), con el sistema en español o en inglés y aunque iCloud sincronice tu Escritorio.
> Usarás la app **Terminal** (zsh). No necesitas permisos de administrador.
> **¿Usas Linux?** Sigue esta misma guía y lee los recuadros 🐧 *Si usas Linux*.

**Antes de empezar, verifica:**

- [ ] Docker Desktop está abierto y la ballena de la barra de menús está quieta.
- [ ] Tienes a la mano tu número de cuenta.
- [ ] Tienes tu hoja para responder (ver `HOJA_DE_RESPUESTAS.md`).

**Dos marcas que verás en toda la guía:**

- 🖥️ **ANFITRIÓN** → escribes en la Terminal de macOS. El inicio de línea se ve como `ana@MacBook ~ %`
- 🐧 **CONTENEDOR** → escribes en Linux. El inicio de línea se ve como `/practica #`

---

## Sección 1 · Identidad, carpeta de proyecto y bitácora (8 min)

**¿Para qué?** Todo trabajo de administración debe dejar rastro de *quién* lo hizo, *en qué equipo* y *cuándo*. Además, un buen procedimiento debe funcionar en cualquier computadora, no solo en la tuya.

### 1.1 Abre la Terminal 🖥️

`Cmd + Espacio`, escribe `Terminal` y presiona Enter.

Si macOS pregunta *«Terminal quiere acceder a archivos de tu carpeta Escritorio»*, elige **Permitir**. Más adelante Docker puede pedir lo mismo: también **Permitir**.

### 1.2 Bloque de preparación de la sesión 🖥️

Copia y pega el bloque completo. Si en algún momento cierras la Terminal, **repite 1.2, 1.3 y 1.4** y continúa donde ibas.

```bash
setopt interactivecomments 2>/dev/null
ESCRITORIO="$(xdg-user-dir DESKTOP 2>/dev/null)"
if [ -z "$ESCRITORIO" ] || [ "$ESCRITORIO" = "$HOME" ] || [ ! -d "$ESCRITORIO" ]; then
  if [ -d "$HOME/Desktop" ]; then ESCRITORIO="$HOME/Desktop"; else ESCRITORIO="$HOME/Escritorio"; fi
fi
PROYECTO="$ESCRITORIO/practica-docker-sistemas-archivos"
IMAGEN="alpine:3.21"
echo "Tu Escritorio real es: $ESCRITORIO"
```

> **¿Por qué tantas comprobaciones?** En macOS el Escritorio siempre está en `/Users/<tu usuario>/Desktop`, aunque Finder lo *muestre* como «Escritorio». En Linux en español, en cambio, la carpeta física puede llamarse `Escritorio`, y `xdg-user-dir` lo sabe. El bloque pregunta primero al sistema y solo si no obtiene respuesta usa la ruta conocida. Así el mismo procedimiento sirve en cualquier equipo.

### 1.3 Registra tu identidad 🖥️

**Cambia los datos entre comillas por los tuyos** antes de presionar Enter.

```bash
export ALUMNO_NOMBRE="Apellido Apellido Nombre"
export ALUMNO_CUENTA="1234567"
BITACORA="$ESCRITORIO/bitacora_${ALUMNO_CUENTA}.log"
```

> `export` crea una **variable de entorno**: un dato que el sistema operativo entrega a los programas que lanzas desde esta ventana. Más adelante verás que esos datos también *cruzan* hacia el contenedor. Solo duran mientras esta ventana esté abierta.

### 1.4 Función para escribir en la bitácora 🖥️

Pega este bloque tal cual. Define el comando `bitacora`, que muestra la salida completa en pantalla pero **guarda solo las primeras líneas** en el archivo.

```bash
bitacora() {
  local paso="$1" max="${2:-10}" tmp
  tmp="$(mktemp)"
  cat > "$tmp"
  cat "$tmp"
  {
    printf '[%s] (anfitrion) %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$paso"
    awk -v m="$max" 'NR<=m { print "    " $0 }' "$tmp"
  } >> "$BITACORA"
  rm -f "$tmp"
}
```

Forma de uso: `comando | bitacora "Nombre del paso" NumeroMaximoDeLineas`

> Siempre se usa **después de una barra** `|`. Si la escribes sola, la Terminal se queda esperando: presiona `Ctrl + D` para liberarla.

### 1.5 Crea la carpeta del proyecto en el Escritorio y entra en ella 🖥️

```bash
mkdir -p "$PROYECTO"
cd "$ESCRITORIO"
cd "practica-docker-sistemas-archivos"
pwd
```

- `-p` hace el paso **idempotente**: si la carpeta ya existe, no hay error y no se borra nada.
- `cd` cambia de carpeta; `pwd` muestra en cuál estás. Debe terminar en `/Desktop/practica-docker-sistemas-archivos`.
- Abre tu Escritorio en Finder: la carpeta ya está ahí.

### 1.6 Inicia la bitácora y registra tu identidad y tu equipo 🖥️

```bash
[ -f "$BITACORA" ] || echo "Practica Docker y sistemas de archivos" | bitacora "INICIO de la bitacora" 1
env | grep '^ALUMNO_' | bitacora "S1.1 Identidad del alumno (variables de entorno)" 2
hostname -s | bitacora "S1.2 Identificador del dispositivo (hostname)" 1
printf 'Escritorio: %s\nProyecto:   %s\nActual:     %s\n' "$ESCRITORIO" "$PROYECTO" "$PWD" | bitacora "S1.3 Escritorio y carpeta de proyecto" 3
cat "$BITACORA"
```

`hostname -s` devuelve **un solo dato** que identifica tu equipo. Anótalo: lo pondrás en tu hoja.

> ⚠️ **Dato curioso:** macOS ya tiene `ls`, `pwd` y `cd` porque, al igual que Linux, desciende de la familia UNIX. Aun así **no es Linux**: su núcleo se llama Darwin y su sistema de archivos (APFS) no distingue mayúsculas por omisión. Lo comprobarás en las secciones 2 y 7.

📝 **Actividad de la Sección 1 → responde en tu hoja las preguntas 1 y 2.**

---

## Sección 2 · Tres mundos, tres nombres (8 min)

**¿Para qué?** Vas a comprobar con evidencia que Docker en macOS **no** ejecuta los contenedores directamente sobre macOS, sino dentro de una máquina virtual Linux, y que cada «mundo» guarda sus archivos en un lugar distinto.

### 2.1 ¿Quién habla con quién? 🖥️

```bash
docker version --format 'Cliente: {{.Client.Os}}/{{.Client.Arch}} | Servidor: {{.Server.Os}}/{{.Server.Arch}}' | bitacora "S2.1 Cliente vs servidor Docker" 1
uname -sr | bitacora "S2.2 Sistema operativo y kernel del anfitrion" 1
docker info --format 'Sistema: {{.OperatingSystem}} | Kernel: {{.KernelVersion}}' | bitacora "S2.3 Maquina virtual de Docker" 1
docker run --rm "$IMAGEN" sh -c 'uname -r; hostname; head -n 2 /etc/os-release' | bitacora "S2.4 Dentro de un contenedor: kernel, nombre y distribucion" 4
```

Observa: el **cliente** (el comando `docker` que escribes) es `darwin` (macOS), pero el **servidor** (el motor que ejecuta los contenedores) es `linux`. Tu Mac reporta un kernel `Darwin`; la VM y el contenedor reportan el **mismo** kernel Linux.

> 🐧 **Si usas Linux con Docker Engine** (sin Docker Desktop): no hay máquina virtual intermedia. El kernel de tu equipo (S2.2) será **igual** al del contenedor (S2.4). Esa diferencia es justamente lo que debes explicar en la pregunta 4.

### 2.2 Lo que se borra y lo que se queda 🖥️

```bash
docker run --rm "$IMAGEN" sh -c 'echo efimero > /tmp/prueba.txt; ls /tmp' | bitacora "S2.5 Contenedor A escribe en /tmp" 3
docker run --rm "$IMAGEN" sh -c 'ls /tmp; echo fin-del-listado' | bitacora "S2.6 Contenedor B busca /tmp/prueba.txt" 3
docker volume create vol-practica > /dev/null
docker run --rm -e ALUMNO_CUENTA -v vol-practica:/datos "$IMAGEN" sh -c 'echo firma de $ALUMNO_CUENTA > /datos/firma.txt'
docker run --rm -v vol-practica:/datos "$IMAGEN" cat /datos/firma.txt | bitacora "S2.7 Otro contenedor lee el volumen" 2
docker volume inspect vol-practica --format '{{ .Mountpoint }}' | bitacora "S2.8 Donde vive el volumen (ruta dentro de la VM)" 1
{ [ -d /var/lib/docker/volumes ] && echo "EXISTE en el anfitrion" || echo "NO EXISTE en el anfitrion"; } | bitacora "S2.9 Existe esa ruta en mi sistema?" 1
```

Qué acabas de comprobar:

- El archivo de `/tmp` **desapareció**: vivía en la capa efímera del contenedor A, que se borró al terminar (`--rm`).
- La firma del volumen **sobrevivió**: el volumen vive en la máquina virtual, no en el contenedor.
- Docker dice que el volumen está en `/var/lib/docker/volumes/...`, pero esa ruta **no existe en tu Mac**. Está en el disco de la VM, que macOS guarda como un solo archivo de disco virtual (`Docker.raw`) dentro de tu carpeta `Library`.

> 🐧 **Si usas Linux con Docker Engine:** S2.9 dirá `EXISTE`, porque los volúmenes viven directamente en tu disco (solo el administrador puede entrar a esa carpeta).

📝 **Actividad de la Sección 2 → responde en tu hoja las preguntas 3, 4 y 5.**

---

## Sección 3 · Entrar al contenedor y navegar (8 min)

**¿Para qué?** Los servidores Linux casi nunca tienen interfaz gráfica. Moverte con soltura entre carpetas usando solo el teclado es la habilidad número uno de quien administra uno.

### 3.1 Entra al contenedor 🖥️ → 🐧

Este comando es largo; cópialo **en una sola línea**:

```bash
docker run -it --rm -e ALUMNO_NOMBRE -e ALUMNO_CUENTA -v "$PROYECTO:/practica" -v "$BITACORA:/bitacora.log" -w /practica "$IMAGEN" sh
```

| Parte | Qué hace |
|---|---|
| `-it` | Abre una sesión interactiva (puedes escribir dentro). |
| `--rm` | Borra el contenedor al salir: su capa efímera desaparece. |
| `-e ALUMNO_NOMBRE -e ALUMNO_CUENTA` | Pasa tus variables de entorno de macOS al contenedor. |
| `-v "$PROYECTO:/practica"` | Tu carpeta del Escritorio aparece dentro como `/practica`. |
| `-v "$BITACORA:/bitacora.log"` | Tu bitácora del Escritorio aparece dentro como `/bitacora.log`. |
| `-w /practica` | Empiezas dentro de `/practica`. |

El inicio de línea cambia a `/practica #`. **Ya estás en Linux.**

> 🐧 **Si usas Linux** y aparece `permission denied ... docker.sock`, tu usuario no está en el grupo `docker`: antepón `sudo` a los comandos `docker` o pide ayuda al profesor.

### 3.2 Prepara el registro dentro del contenedor 🐧

Pega esta línea completa. Crea el comando `reg`, equivalente a `bitacora` pero dentro del contenedor. Si sales del contenedor y vuelves a entrar, pégala de nuevo.

```sh
reg() { t=$(mktemp); cat > "$t"; cat "$t"; { echo "[$(date '+%Y-%m-%d %H:%M:%S')] (contenedor, hora UTC) $1"; awk -v m="${2:-10}" 'NR<=m { print "    " $0 }' "$t"; } >> /bitacora.log; rm -f "$t"; }
```

Forma de uso: `comando | reg "Nombre del paso" NumeroMaximoDeLineas`

```sh
env | grep ALUMNO_ | reg "S3.0 Mis variables de entorno vistas desde el contenedor" 2
hostname | reg "S3.0 Nombre del contenedor (no es tu equipo)" 1
```

El contenedor registra la hora en **UTC** (6 horas adelante del centro de México): otra diferencia entre mundos.

### 3.3 Navega 🐧

Escribe uno por uno y observa cada salida:

```sh
pwd
ls
ls -l
ls -la
```

| Bandera | Qué agrega |
|---|---|
| `-l` | Formato largo: permisos, dueño, tamaño y fecha. |
| `-a` | Muestra ocultos (los que empiezan con `.`), incluidos `.` (aquí) y `..` (arriba). |
| `-h` | Tamaños legibles (K, M, G). Se combina con `-l`. |
| `-R` | Recorre también las subcarpetas. |

Ahora sal a la raíz del contenedor y explora:

```sh
cd /
pwd
ls -l / | reg "S3.1 Raiz del contenedor (ls -l /)" 12
cd etc
pwd
ls -lh | head -n 8
cd ..
pwd
cd ~
pwd
cd /practica
pwd | reg "S3.2 De regreso a la carpeta compartida" 1
ls -la | reg "S3.3 Contenido de /practica (ls -la)" 12
```

| Ruta | Tipo | Significado |
|---|---|---|
| `/etc` | Absoluta (empieza con `/`) | Funciona desde cualquier lugar. |
| `etc` | Relativa | Solo funciona si estás en `/`. |
| `..` | Relativa | La carpeta de arriba. |
| `~` | Atajo | La carpeta personal del usuario (`/root`). |

**Carpetas importantes de Linux** (estándar FHS) y su equivalente aproximado:

| Linux | Para qué sirve | En macOS sería algo como |
|---|---|---|
| `/etc` | Configuración del sistema | `/etc` (también existe) y `/Library/Preferences` |
| `/var` | Datos que cambian: bitácoras, bases de datos | `/var/log`, app Consola |
| `/tmp` | Temporales | `/tmp` y `$TMPDIR` |
| `/root` | Carpeta del administrador | `/var/root` |
| `/bin`, `/usr` | Programas | `/Applications`, `/usr/bin` |
| `/home/ana` | Carpetas de usuarios | `/Users/ana` |

📝 **Actividad de la Sección 3 → responde en tu hoja la pregunta 6.**

---

## Sección 4 · Construir y editar (12 min)

**¿Para qué?** Organizar carpetas, respaldar antes de modificar, mover y depurar archivos es el trabajo diario de un administrador. En Linux **no existe papelera**: lo que borras con `rm` se va.

### 4.1 Crea una estructura de carpetas 🐧

```sh
cd /practica
mkdir -p datos/entrada datos/salida docs respaldo salidas
ls -R | reg "S4.1 Estructura creada (ls -R)" 15
```

`-p` crea las carpetas intermedias y **no marca error si ya existen** (idempotente).

👉 Mira tu Escritorio en Finder: las carpetas **ya aparecieron** dentro de `practica-docker-sistemas-archivos`.

### 4.2 Escribe, copia, mueve y borra 🐧

```sh
printf 'Proyecto: inventario de equipos de computo\nResponsable: %s (%s)\n' "$ALUMNO_NOMBRE" "$ALUMNO_CUENTA" > docs/notas.txt
cat docs/notas.txt
cp docs/notas.txt respaldo/notas_respaldo.txt
echo "borrador sin revisar" > datos/borrador.txt
mv datos/borrador.txt datos/salida/reporte.txt
touch datos/basura.tmp
ls datos
rm -f datos/basura.tmp
ls -lR datos respaldo | reg "S4.2 Despues de cp, mv y rm" 15
```

| Comando | Qué hizo |
|---|---|
| `>` | Escribe en un archivo **reemplazando** su contenido (`>>` agregaría al final). |
| `cp origen destino` | Copia: ahora hay dos archivos. |
| `mv origen destino` | Mueve y, a la vez, cambia el nombre: sigue habiendo uno solo. |
| `rm -f` | Borra; `-f` evita el error si el archivo ya no existe (idempotente). |

### 4.3 Edita un archivo sin abrirlo 🐧

```sh
sed -i 's/borrador sin revisar/reporte revisado y aprobado/' datos/salida/reporte.txt
cat datos/salida/reporte.txt | reg "S4.3 Archivo editado con sed" 3
```

`sed -i` busca y reemplaza texto dentro del archivo: así se modifican configuraciones en cientos de servidores a la vez.

### 4.4 Edita el mismo archivo desde los dos mundos 🐧 + 🖥️

**a) Desde Linux con el editor `vi`** 🐧

```sh
vi docs/notas.txt
```

Dentro de `vi` teclea exactamente:

1. `G` (mayúscula) → va a la última línea.
2. `o` (minúscula) → abre una línea nueva y entra en modo escritura.
3. Escribe: `Editado con vi dentro del contenedor`
4. Presiona `Esc`.
5. Escribe `:wq` y presiona Enter (guardar y salir).

> ¿Te atoraste? Presiona `Esc`, escribe `:q!` y Enter: sales sin guardar y lo intentas de nuevo.

**b) Desde macOS con TextEdit** 🖥️ (sin cerrar la Terminal)

1. En Finder abre: Escritorio › `practica-docker-sistemas-archivos` › `docs` › `notas.txt`.
2. Se abre en **TextEdit**. Agrega al final la línea: `Editado con TextEdit en macOS`
3. Guarda (`Cmd + S`) y cierra. Si TextEdit propone otro formato, conserva **texto sin formato (.txt)**.

> 🐧 **Si usas Linux:** usa el editor de texto de tu escritorio (gedit, Kate, etc.) y escribe `Editado con el editor grafico en Linux`.

**c) Comprueba desde el contenedor** 🐧

```sh
cat docs/notas.txt | reg "S4.4 notas.txt editado desde los dos mundos" 6
```

Es **un solo archivo** con dos nombres: `/Users/<tu usuario>/Desktop/practica-docker-sistemas-archivos/docs/notas.txt` en macOS y `/practica/docs/notas.txt` en Linux.

### 4.5 ¿Mayúsculas o minúsculas? 🐧

Esta prueba se hace en una carpeta **propia del contenedor** (no en la compartida):

```sh
mkdir -p /tmp/caso
cd /tmp/caso
echo A > Nota.txt
echo B > nota.txt
ls -l
ls | wc -l | reg "S4.5 Archivos Nota.txt y nota.txt en Linux" 1
cd /practica
```

Anota cuántos archivos quedaron. En la Sección 7 harás la misma prueba en macOS.

📝 **Actividad de la Sección 4 → responde en tu hoja las preguntas 7 y 8** (la 8 la completarás en la Sección 7).

---

## Sección 5 · Analizar datos (8 min)

**¿Para qué?** Un administrador informático vive leyendo listas: inventarios, bitácoras de acceso, reportes exportados. Saber filtrar y contar desde la terminal te ahorra abrir Excel con archivos de millones de renglones.

### 5.1 Crea el inventario 🐧

Pega el bloque completo (desde `cat` hasta `EOF`):

```sh
cat > datos/entrada/inventario.csv << 'EOF'
id,equipo,area,sistema,estado
1,PC-ADM-01,Administracion,Windows 11,Operativo
2,PC-ADM-02,Administracion,Windows 10,Mantenimiento
3,LAP-CON-01,Contabilidad,macOS,Operativo
4,PC-CON-02,Contabilidad,Windows 11,Operativo
5,SRV-WEB-01,Sistemas,Linux,Operativo
6,SRV-BD-01,Sistemas,Linux,Mantenimiento
7,PC-RH-01,Recursos Humanos,Windows 11,Baja
8,LAP-DIR-01,Direccion,macOS,Operativo
9,PC-ALM-01,Almacen,Windows 10,Mantenimiento
10,SRV-RES-01,Sistemas,Linux,Operativo
EOF
```

### 5.2 Lee y filtra 🐧

```sh
cat datos/entrada/inventario.csv
less datos/entrada/inventario.csv
```

Dentro de `less`: flechas para moverte, `/Linux` + Enter para buscar, `q` para salir.

```sh
wc -l datos/entrada/inventario.csv | reg "S5.1 Lineas del inventario (wc -l)" 1
grep -n "Linux" datos/entrada/inventario.csv | reg "S5.2 Servidores Linux (grep -n)" 5
grep -i "MANTENIMIENTO" datos/entrada/inventario.csv
grep -c "Mantenimiento" datos/entrada/inventario.csv | reg "S5.3 Equipos en mantenimiento (grep -c)" 1
grep "Mantenimiento" datos/entrada/inventario.csv > datos/salida/en_mantenimiento.csv
wc -l datos/salida/en_mantenimiento.csv
```

| Opción | Qué hace |
|---|---|
| `grep "texto" archivo` | Muestra solo las líneas que contienen el texto. |
| `-n` | Agrega el número de línea. |
| `-i` | Ignora mayúsculas y minúsculas. |
| `-c` | En lugar de mostrar, **cuenta** las líneas que coinciden. |
| `wc -l` | Cuenta líneas (`-w` palabras, `-c` bytes). |

### 5.3 Reto 🐧

Escribe **tú** el comando que cuenta cuántos equipos usan Windows y regístralo agregando al final `| reg "S5.4 Reto: equipos con Windows" 3`. Anota el comando y el resultado en tu hoja.

📝 **Actividad de la Sección 5 → responde en tu hoja las preguntas 9 y 10.**

---

## Sección 6 · Control del sistema y red (6 min)

**¿Para qué?** Antes de culpar a «la aplicación», un administrador revisa tres cosas: ¿hay espacio en disco?, ¿qué está consumiendo recursos?, ¿hay conexión?

### 6.1 Disco 🐧

```sh
df -h | reg "S6.1 Espacio en disco (df -h)" 12
mount | grep -E ' on / | on /practica ' | reg "S6.2 Tipo de sistema de archivos de / y de /practica" 3
```

Compara el tamaño y el tipo de `/` (el disco del contenedor) con los de `/practica` (tu carpeta de macOS).

### 6.2 Procesos 🐧

Primero en vivo (sal con `q`):

```sh
top
```

Luego una sola captura para la bitácora:

```sh
top -b -n 1 | head -n 12 | reg "S6.3 Procesos del contenedor (top)" 12
```

Abre el **Monitor de Actividad** de macOS (`Cmd + Espacio` › «Monitor de Actividad») y compara cuántos procesos ves allá y cuántos aquí.

### 6.3 Red 🐧

```sh
ping -c 3 -w 6 8.8.8.8 | reg "S6.4 Red: ping a un servidor de Internet" 8
```

Si la red de la escuela bloquea `ping` y no hay respuesta, regístralo de todos modos y prueba la interfaz local:

```sh
ping -c 3 127.0.0.1 | reg "S6.4b Red: ping a la interfaz local" 8
```

### 6.4 Guarda la evidencia y sal del contenedor 🐧 → 🖥️

```sh
ls -lR /practica > /practica/salidas/estructura_final.txt
echo "Fin de la parte en el contenedor" | reg "S6.5 Cierre del contenedor" 1
exit
```

El inicio de línea vuelve a ser el de tu Mac (`… %`). El contenedor ya no existe; lo que quedó en `/practica` sigue en tu Escritorio.

📝 **Actividad de la Sección 6 → responde en tu hoja las preguntas 11 y 12.**

---

## Sección 7 · Cierre, empaquetado y entrega (6 min) 🖥️

> Si cerraste la Terminal, repite primero 1.2, 1.3 y 1.4.

### 7.1 La prueba de mayúsculas, ahora en macOS

```bash
cd "$PROYECTO"
mkdir -p caso
echo A > caso/Nota.txt
echo B > caso/nota.txt
printf 'Cantidad: %s\nContenido de Nota.txt: %s\n' "$(ls caso | wc -l | tr -d ' ')" "$(cat caso/Nota.txt)" | bitacora "S7.1 Archivos Nota.txt y nota.txt en el anfitrion" 2
```

Compara con lo que obtuviste en el contenedor (S4.5) y completa la pregunta 8.

> 🐧 **Si usas Linux:** tu sistema de archivos (ext4, btrfs…) sí distingue mayúsculas, así que verás `Cantidad: 2`. Es correcto: explícalo en la pregunta 8.

### 7.2 Lo que hizo el contenedor, visto desde macOS

```bash
find . -not -name '.DS_Store' | sort | bitacora "S7.2 Archivos del proyecto vistos desde el anfitrion" 25
```

### 7.3 Cierra la bitácora y empaqueta

```bash
printf 'Alumno: %s - %s\nEquipo: %s\n' "$ALUMNO_CUENTA" "$ALUMNO_NOMBRE" "$(hostname -s)" | bitacora "S7.3 FIN de la practica" 2
cp -f "$BITACORA" "$PROYECTO/salidas/"
ZIP="$ESCRITORIO/entrega_${ALUMNO_CUENTA}.zip"
cd "$ESCRITORIO"
rm -f "$ZIP"
zip -rq "$ZIP" "practica-docker-sistemas-archivos" -x '*.DS_Store'
{ echo "$ZIP"; shasum -a 256 "$ZIP" | cut -d' ' -f1; } | bitacora "S7.4 Paquete de entrega y huella SHA-256" 2
echo "Lineas en la bitacora: $(wc -l < "$BITACORA")"
open "$ESCRITORIO"
```

- `rm -f` antes de `zip` garantiza que el paquete se crea desde cero cada vez (idempotente).
- La **huella SHA-256** es una «firma» del archivo: si alguien cambia un solo byte del `.zip`, la huella cambia. Anota **los primeros 8 caracteres** en tu hoja.
- La bitácora debe tener menos de 300 líneas.

> 🐧 **Si usas Linux y no tienes `zip`:** sustituye las líneas de `ZIP`, `zip` y `shasum` por:
> ```bash
> ZIP="$ESCRITORIO/entrega_${ALUMNO_CUENTA}.tar.gz"
> cd "$ESCRITORIO" && tar -czf "$ZIP" "practica-docker-sistemas-archivos"
> { echo "$ZIP"; sha256sum "$ZIP" | cut -d' ' -f1; } | bitacora "S7.4 Paquete de entrega y huella SHA-256" 2
> xdg-open "$ESCRITORIO"
> ```

### 7.4 Envía el correo

En la ventana de Finder que se abrió están los dos archivos que debes adjuntar:

| Campo | Valor |
|---|---|
| **Para** | correo que indique el profesor (`@uaemex.mx`) |
| **Asunto** | `[SO] Practica Docker FS | <numero de cuenta> | <Apellidos Nombre>` |
| **Adjuntos** | `bitacora_<cuenta>.log` **y** `entrega_<cuenta>.zip` (o `.tar.gz` en Linux) |
| **Cuerpo** | Nombre completo, número de cuenta, grupo y versión de macOS (o distribución de Linux). |

### 7.5 Entrega tu hoja

Revisa que tu hoja tenga el encabezado completo (incluido tu `hostname` y los 8 caracteres de la huella), fírmala y entrégala al profesor antes de salir.

---

## Si algo falla

| Síntoma | Causa probable | Solución |
|---|---|---|
| `command not found: docker` o `Cannot connect to the Docker daemon` | Docker Desktop cerrado o iniciando | Abre Docker Desktop, espera a que la ballena se quede quieta y repite el paso. |
| `Operation not permitted` al tocar el Escritorio | macOS no dio permiso a Terminal o a Docker | Configuración del Sistema › Privacidad y seguridad › Archivos y carpetas › activa «Escritorio» para Terminal y Docker. |
| `toomanyrequests` al descargar la imagen | Límite de descargas de Docker Hub en la red escolar | Avisa al profesor o ejecuta `docker login` con una cuenta gratuita. |
| `invalid spec` o `invalid mode` al entrar al contenedor | `$PROYECTO` o `$BITACORA` vacíos (cerraste la Terminal) | Repite 1.2, 1.3 y 1.4. |
| Dentro del contenedor `/bitacora.log` es una carpeta | La bitácora no existía al entrar | `exit`, ejecuta `rmdir "$BITACORA"`, repite 1.6 y vuelve a entrar. |
| La Terminal se queda «esperando» sin hacer nada | Usaste `bitacora` sin `|` antes | `Ctrl + D` o `Ctrl + C` y repite con la barra. |
| `zsh: command not found: #` | Pegaste comentarios sin el paso 1.2 | Ejecuta 1.2 de nuevo. |
| Atorado en `vi` | Modo de escritura | `Esc`, luego `:q!` y Enter. |
| Atorado en `less` o `top` | Esperan una tecla | Presiona `q`. |
| `ping` no termina | Red bloqueada | `Ctrl + C`, y usa el paso 6.4b. |
| Cerraste el contenedor sin querer | — | Repite 3.1 y 3.2; continúa donde ibas. Los archivos de `/practica` siguen ahí. |
