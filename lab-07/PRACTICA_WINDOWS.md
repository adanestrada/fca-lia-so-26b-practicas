# Práctica «Un archivo, tres mundos» · Variante **Windows 10 / 11**

> Funciona en Windows 10 y 11, en español o en inglés, con o sin OneDrive sincronizando el Escritorio.
> Usarás **Windows PowerShell** (ya viene instalado). No necesitas permisos de administrador.

**Antes de empezar, verifica:**

- [ ] Docker Desktop está abierto y la ballena de la barra de tareas está quieta.
- [ ] Tienes a la mano tu número de cuenta.
- [ ] Tienes tu hoja para responder (ver `HOJA_DE_RESPUESTAS.md`).

**Dos marcas que verás en toda la guía:**

- 🖥️ **ANFITRIÓN** → escribes en PowerShell. El inicio de línea se ve como `PS C:\Users\...>`
- 🐧 **CONTENEDOR** → escribes en Linux. El inicio de línea se ve como `/practica #`

---

## Sección 1 · Identidad, carpeta de proyecto y bitácora (8 min)

**¿Para qué?** Todo trabajo de administración debe dejar rastro de *quién* lo hizo, *en qué equipo* y *cuándo*. Además, un buen procedimiento debe funcionar en cualquier computadora, no solo en la tuya.

### 1.1 Abre PowerShell 🖥️

Presiona `Windows + R`, escribe `powershell` y presiona Enter.
(También sirve «Terminal» desde el menú Inicio).

### 1.2 Bloque de preparación de la sesión 🖥️

Copia y pega el bloque completo. Si en algún momento cierras PowerShell, **repite 1.2, 1.3 y 1.4** y continúa donde ibas.

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ESCRITORIO = [Environment]::GetFolderPath("Desktop")
$PROYECTO   = Join-Path $ESCRITORIO "practica-docker-sistemas-archivos"
$IMAGEN     = "alpine:3.21"
Write-Host "Tu Escritorio real es: $ESCRITORIO"
```

> **¿Por qué no escribimos `C:\Users\...\Desktop` directamente?** Porque esa ruta cambia de una computadora a otra: el nombre de usuario es distinto, Windows en español *muestra* «Escritorio» y, si OneDrive respalda tu Escritorio, la ruta real es algo como `C:\Users\ana\OneDrive\Escritorio`. `GetFolderPath("Desktop")` le pregunta a Windows dónde está **realmente**, sin adivinar.

### 1.3 Registra tu identidad 🖥️

**Cambia los datos entre comillas por los tuyos** antes de presionar Enter. Si tu nombre tiene acentos y luego ves caracteres raros, escríbelo sin acentos.

```powershell
$env:ALUMNO_NOMBRE = "Apellido Apellido Nombre"
$env:ALUMNO_CUENTA = "1234567"
$BITACORA = Join-Path $ESCRITORIO ("bitacora_" + $env:ALUMNO_CUENTA + ".log")
```

> `$env:` crea una **variable de entorno**: un dato que el sistema operativo entrega a los programas que lanzas desde esta ventana. Más adelante verás que esos datos también *cruzan* hacia el contenedor. Solo duran mientras esta ventana esté abierta.

### 1.4 Función para escribir en la bitácora 🖥️

Pega este bloque tal cual. Define el comando `Bitacora`, que muestra la salida completa en pantalla pero **guarda solo las primeras líneas** en el archivo.

```powershell
function Bitacora {
    param([string]$Paso, [object[]]$Salida = @(), [int]$Max = 10)
    $Salida | Out-Host
    $lineas = @("[{0}] (anfitrion) {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Paso)
    $lineas += @($Salida | Select-Object -First $Max | ForEach-Object { "    $_" })
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::AppendAllLines($BITACORA, [string[]]$lineas, $utf8)
}
```

Forma de uso: `Bitacora "Nombre del paso" (comando) NumeroMaximoDeLineas`

### 1.5 Crea la carpeta del proyecto en el Escritorio y entra en ella 🖥️

```powershell
New-Item -ItemType Directory -Force -Path $PROYECTO | Out-Null
cd $ESCRITORIO
cd "practica-docker-sistemas-archivos"
pwd
```

- `-Force` hace el paso **idempotente**: si la carpeta ya existe, no hay error y no se borra nada.
- `cd` cambia de carpeta; `pwd` muestra en cuál estás. Debe terminar en `...\practica-docker-sistemas-archivos`.
- Abre tu Escritorio en el Explorador: la carpeta ya está ahí.

### 1.6 Inicia la bitácora y registra tu identidad y tu equipo 🖥️

```powershell
if (-not (Test-Path $BITACORA)) { Bitacora "INICIO de la bitacora - Practica Docker y sistemas de archivos" }
Bitacora "S1.1 Identidad del alumno (variables de entorno)" (Get-ChildItem env:ALUMNO_* | ForEach-Object { "$($_.Name)=$($_.Value)" })
Bitacora "S1.2 Identificador del dispositivo (COMPUTERNAME)" @($env:COMPUTERNAME)
Bitacora "S1.3 Escritorio y carpeta de proyecto" @("Escritorio: $ESCRITORIO", "Proyecto:   $PROYECTO", "Actual:     $((Get-Location).Path)")
Get-Content $BITACORA
```

`$env:COMPUTERNAME` es **una sola variable** que identifica tu equipo. Anótala: la pondrás en tu hoja.

> ⚠️ **Trampa frecuente:** en PowerShell existen `ls`, `pwd` y `cd`, pero son *alias* de comandos de Windows. Por eso `ls -la` **falla aquí** y funciona dentro del contenedor. Mismo nombre, otro mundo.

📝 **Actividad de la Sección 1 → responde en tu hoja las preguntas 1 y 2.**

---

## Sección 2 · Tres mundos, tres nombres (8 min)

**¿Para qué?** Vas a comprobar con evidencia que Docker en Windows **no** ejecuta los contenedores directamente sobre Windows, sino dentro de una máquina virtual Linux, y que cada «mundo» guarda sus archivos en un lugar distinto.

### 2.1 ¿Quién habla con quién? 🖥️

```powershell
Bitacora "S2.1 Cliente vs servidor Docker" (docker version --format 'Cliente: {{.Client.Os}}/{{.Client.Arch}} | Servidor: {{.Server.Os}}/{{.Server.Arch}}')
Bitacora "S2.2 Sistema operativo del anfitrion" @([Environment]::OSVersion.VersionString)
Bitacora "S2.3 Maquina virtual de Docker" (docker info --format 'Sistema: {{.OperatingSystem}} | Kernel: {{.KernelVersion}}')
Bitacora "S2.4 Dentro de un contenedor: kernel, nombre y distribucion" (docker run --rm $IMAGEN sh -c "uname -r; hostname; head -n 2 /etc/os-release") 4
```

Observa: el **cliente** (el comando `docker` que escribes) es `windows`, pero el **servidor** (el motor que ejecuta los contenedores) es `linux`. Compara además el kernel de la VM (S2.3) con el que reporta el contenedor (primera línea de S2.4).

> Windows 11 también se reporta como «Windows NT 10.0»; lo distingue el número de compilación (22000 o mayor).

### 2.2 Lo que se borra y lo que se queda 🖥️

```powershell
Bitacora "S2.5 Contenedor A escribe en /tmp" (docker run --rm $IMAGEN sh -c "echo efimero > /tmp/prueba.txt; ls /tmp") 3
Bitacora "S2.6 Contenedor B busca /tmp/prueba.txt" (docker run --rm $IMAGEN sh -c "ls /tmp; echo fin-del-listado") 3
docker volume create vol-practica | Out-Null
docker run --rm -e ALUMNO_CUENTA -v vol-practica:/datos $IMAGEN sh -c 'echo firma de $ALUMNO_CUENTA > /datos/firma.txt'
Bitacora "S2.7 Otro contenedor lee el volumen" (docker run --rm -v vol-practica:/datos $IMAGEN cat /datos/firma.txt) 2
Bitacora "S2.8 Donde vive el volumen (ruta dentro de la VM)" (docker volume inspect vol-practica --format '{{ .Mountpoint }}') 1
Bitacora "S2.9 Existe esa ruta en Windows?" @("Test-Path /var/lib/docker/volumes -> " + (Test-Path "/var/lib/docker/volumes")) 1
```

Qué acabas de comprobar:

- El archivo de `/tmp` **desapareció**: vivía en la capa efímera del contenedor A, que se borró al terminar (`--rm`).
- La firma del volumen **sobrevivió**: el volumen vive en la máquina virtual, no en el contenedor.
- Docker dice que el volumen está en `/var/lib/docker/volumes/...`, pero esa ruta **no existe en Windows** (`False`). Esa carpeta está en el disco de la VM, que Windows guarda como un solo archivo de disco virtual dentro de `AppData\Local\Docker\wsl`.

📝 **Actividad de la Sección 2 → responde en tu hoja las preguntas 3, 4 y 5.**

---

## Sección 3 · Entrar al contenedor y navegar (8 min)

**¿Para qué?** Los servidores Linux casi nunca tienen interfaz gráfica. Moverte con soltura entre carpetas usando solo el teclado es la habilidad número uno de quien administra uno.

### 3.1 Entra al contenedor 🖥️ → 🐧

Este comando es largo; cópialo **en una sola línea**:

```powershell
docker run -it --rm -e ALUMNO_NOMBRE -e ALUMNO_CUENTA -v "${PROYECTO}:/practica" -v "${BITACORA}:/bitacora.log" -w /practica $IMAGEN sh
```

| Parte | Qué hace |
|---|---|
| `-it` | Abre una sesión interactiva (puedes escribir dentro). |
| `--rm` | Borra el contenedor al salir: su capa efímera desaparece. |
| `-e ALUMNO_NOMBRE -e ALUMNO_CUENTA` | Pasa tus variables de entorno de Windows al contenedor. |
| `-v "${PROYECTO}:/practica"` | Tu carpeta del Escritorio aparece dentro como `/practica`. |
| `-v "${BITACORA}:/bitacora.log"` | Tu bitácora del Escritorio aparece dentro como `/bitacora.log`. |
| `-w /practica` | Empiezas dentro de `/practica`. |

El inicio de línea cambia a `/practica #`. **Ya estás en Linux.**

> Fíjate en `${PROYECTO}` con llaves: sin ellas PowerShell confundiría `$PROYECTO:` con otra cosa. Detalles así son los que distinguen la nomenclatura de cada mundo.

### 3.2 Prepara el registro dentro del contenedor 🐧

Pega esta línea completa. Crea el comando `reg`, equivalente a `Bitacora` pero en Linux. Si sales del contenedor y vuelves a entrar, pégala de nuevo.

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

| Linux | Para qué sirve | En Windows sería algo como |
|---|---|---|
| `/etc` | Configuración del sistema | Registro / `C:\ProgramData` |
| `/var` | Datos que cambian: bitácoras, bases de datos | `C:\ProgramData`, visor de eventos |
| `/tmp` | Temporales | `%TEMP%` |
| `/root` | Carpeta del administrador | `C:\Users\Administrador` |
| `/bin`, `/usr` | Programas | `C:\Program Files`, `C:\Windows\System32` |

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

👉 Mira tu Escritorio en el Explorador de Windows: las carpetas **ya aparecieron** dentro de `practica-docker-sistemas-archivos`.

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

**b) Desde Windows con el Bloc de notas** 🖥️ (sin cerrar PowerShell)

1. En el Explorador abre: Escritorio › `practica-docker-sistemas-archivos` › `docs` › `notas.txt`.
2. Ábrelo con el **Bloc de notas** y agrega al final la línea: `Editado con el Bloc de notas en Windows`
3. Guarda (`Ctrl + S`) y cierra.

**c) Comprueba desde el contenedor** 🐧

```sh
cat docs/notas.txt | reg "S4.4 notas.txt editado desde los dos mundos" 6
```

Es **un solo archivo** con dos nombres: `C:\...\Escritorio\practica-docker-sistemas-archivos\docs\notas.txt` en Windows y `/practica/docs/notas.txt` en Linux.

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

Anota cuántos archivos quedaron. En la Sección 7 harás la misma prueba en Windows.

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

Compara el tamaño y el tipo de `/` (el disco del contenedor) con los de `/practica` (tu carpeta de Windows).

### 6.2 Procesos 🐧

Primero en vivo (sal con `q`):

```sh
top
```

Luego una sola captura para la bitácora:

```sh
top -b -n 1 | head -n 12 | reg "S6.3 Procesos del contenedor (top)" 12
```

Abre el Administrador de tareas de Windows (`Ctrl + Shift + Esc`) y compara cuántos procesos ves allá y cuántos aquí.

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

El inicio de línea vuelve a ser `PS C:\...>`. El contenedor ya no existe; lo que quedó en `/practica` sigue en tu Escritorio.

📝 **Actividad de la Sección 6 → responde en tu hoja las preguntas 11 y 12.**

---

## Sección 7 · Cierre, empaquetado y entrega (6 min) 🖥️

> Si cerraste PowerShell, repite primero 1.2, 1.3 y 1.4.

### 7.1 La prueba de mayúsculas, ahora en Windows

```powershell
cd $PROYECTO
New-Item -ItemType Directory -Force -Path "caso" | Out-Null
Set-Content -Path "caso\Nota.txt" -Value "A"
Set-Content -Path "caso\nota.txt" -Value "B"
Bitacora "S7.1 Archivos Nota.txt y nota.txt en Windows (NTFS)" @("Cantidad: $((Get-ChildItem 'caso').Count)", "Contenido de Nota.txt: $(Get-Content 'caso\Nota.txt')") 2
```

Compara con lo que obtuviste en Linux (S4.5) y completa la pregunta 8.

### 7.2 Lo que hizo el contenedor, visto desde Windows

```powershell
Bitacora "S7.2 Archivos del proyecto vistos desde Windows" (Get-ChildItem -Recurse -Name) 25
```

### 7.3 Cierra la bitácora y empaqueta

```powershell
Bitacora "S7.3 FIN de la practica" @("Alumno: $env:ALUMNO_CUENTA - $env:ALUMNO_NOMBRE", "Equipo: $env:COMPUTERNAME") 2
Copy-Item -Path $BITACORA -Destination (Join-Path $PROYECTO "salidas") -Force
$ZIP = Join-Path $ESCRITORIO ("entrega_" + $env:ALUMNO_CUENTA + ".zip")
Compress-Archive -Path $PROYECTO -DestinationPath $ZIP -Force
Bitacora "S7.4 Paquete de entrega y huella SHA-256" @($ZIP, (Get-FileHash $ZIP -Algorithm SHA256).Hash) 2
"Lineas en la bitacora: " + (Get-Content $BITACORA).Count
explorer $ESCRITORIO
```

- `-Force` en `Compress-Archive` reemplaza el `.zip` si ya existía (idempotente).
- La **huella SHA-256** es una «firma» del archivo: si alguien cambia un solo byte del `.zip`, la huella cambia. Anota **los primeros 8 caracteres** en tu hoja.
- La bitácora debe tener menos de 300 líneas.

### 7.4 Envía el correo

En la ventana del Explorador que se abrió están los dos archivos que debes adjuntar:

| Campo | Valor |
|---|---|
| **Para** | correo que indique el profesor (`@uaemex.mx`) |
| **Asunto** | `[SO] Practica Docker FS | <numero de cuenta> | <Apellidos Nombre>` |
| **Adjuntos** | `bitacora_<cuenta>.log` **y** `entrega_<cuenta>.zip` |
| **Cuerpo** | Nombre completo, número de cuenta, grupo y «Windows 10» u «Windows 11». |

### 7.5 Entrega tu hoja

Revisa que tu hoja tenga el encabezado completo (incluido `COMPUTERNAME` y los 8 caracteres de la huella), fírmala y entrégala al profesor antes de salir.

---

## Si algo falla

| Síntoma | Causa probable | Solución |
|---|---|---|
| `docker : The term 'docker' is not recognized` o `error during connect` | Docker Desktop cerrado o iniciando | Abre Docker Desktop, espera a que la ballena se quede quieta y repite el paso. |
| `no matching manifest for windows/amd64` | Docker está en modo contenedores Windows | Clic derecho en la ballena › **Switch to Linux containers**. |
| `toomanyrequests` al descargar la imagen | Límite de descargas de Docker Hub en la red escolar | Avisa al profesor o ejecuta `docker login` con una cuenta gratuita. |
| `invalid spec` o `invalid mode` al entrar al contenedor | `$PROYECTO` o `$BITACORA` vacíos (cerraste PowerShell) | Repite 1.2, 1.3 y 1.4. |
| Dentro del contenedor `/bitacora.log` es una carpeta | La bitácora no existía al entrar | `exit`, ejecuta `Remove-Item $BITACORA` (solo si es carpeta vacía), repite 1.6 y vuelve a entrar. |
| Acentos con símbolos raros | Codificación de la consola | Ya se corrige en 1.2; si persiste, escribe tu nombre sin acentos. |
| `ls -la` marca error | Lo escribiste en PowerShell, no en el contenedor | Revisa el inicio de línea: debe ser `/practica #`. |
| Atorado en `vi` | Modo de escritura | `Esc`, luego `:q!` y Enter. |
| Atorado en `less` o `top` | Esperan una tecla | Presiona `q`. |
| `ping` no termina | Red bloqueada | `Ctrl + C`, y usa el paso 6.4b. |
| Cerraste el contenedor sin querer | — | Repite 3.1 y 3.2; continúa donde ibas. Los archivos de `/practica` siguen ahí. |
