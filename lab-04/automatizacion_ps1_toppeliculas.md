# Práctica 04 — De los comandos sueltos al script: automatización con un archivo `.ps1` parametrizado

**Licenciatura en Informática Administrativa · 3.er semestre**
**Unidad de Aprendizaje: Sistemas Operativos**
**Duración: 35 minutos · Modalidad: laboratorio· Sistema: Windows 10 / 11 (español o inglés)**

---

## 1. Punto de partida y propósito

En la práctica anterior usted extrajo un "Top 10" de películas escribiendo los comandos **uno por uno** en la consola: filtrar, ordenar, recortar y exportar. Funcionó, pero tuvo dos problemas que en un área de sistemas se pagan caro:

1. **No es repetible.** Si mañana le piden el Top 5 en vez del Top 10, hay que volver a teclear todo y confiar en la memoria.
2. **No es auditable.** Nadie más puede reproducir exactamente lo que usted hizo ni comprobar que lo hizo bien.

Hoy va a trabajar con ese mismo proceso, pero **empaquetado en un archivo `.ps1`** que recibe parámetros. Cambiar el resultado ya no implica reescribir comandos: implica cambiar un valor al invocar el script.

### ¿Por qué le importa esto como futuro administrador informático?

En una organización usted no ejecuta tareas una vez; las ejecuta **cada mes, cada cierre, cada auditoría**. Un script parametrizado es la diferencia entre un proceso que depende de una persona y un proceso que pertenece a la institución. Además introduce dos ideas centrales de la administración de sistemas:

- **Idempotencia:** una tarea bien diseñada puede ejecutarse muchas veces sin romper nada. Si la carpeta ya existe, no truena: la reutiliza. Si el reporte ya existe, lo reemplaza en vez de duplicarlo. Esto es lo que permite programar tareas automáticas sin supervisión humana.
- **Trazabilidad:** toda ejecución deja evidencia de *quién*, *cuándo*, *en qué equipo* y *con qué parámetros*. Sin esa evidencia, un resultado correcto y uno inventado se ven exactamente igual.
- **Calidad del dato:** hoy no trabajará con datos de laboratorio, sino con un archivo real de 1000 películas descargado de Internet. Ese archivo viene sucio: la duración es texto (`142 min`), la recaudación trae comas (`28,341,469`), hay campos vacíos y hasta un año que no es un número. Ningún reporte es mejor que los datos que lo alimentan.

### Objetivo de aprendizaje

Al terminar la sesión, el estudiantado será capaz de **ejecutar, interpretar y documentar** un script `.ps1` parametrizado, explicando cómo sus parámetros modifican la salida y por qué el diseño idempotente es deseable en la administración de sistemas.

> **Importante:** el objetivo **no** es que usted programe el script. El objetivo es que lo **explore, lo entienda y lo opere**, que es exactamente lo que hará en su vida profesional con herramientas que otros escribieron.

---

## 2. Qué se entrega (lea esto ANTES de empezar)

| # | Entregable | Cómo se entrega | Cuándo |
|---|---|---|---|
| 1 | **Hoja de respuestas** escrita a mano (Anexo A) | En papel, al profesor | Al terminar la clase |
| 2 | **`P04_TopPeliculas_<cuenta>.zip`** con las salidas generadas | Por correo electrónico | Mismo día |
| 3 | **`Bitacora_P04_<cuenta>.log`** | Por correo, adjunto aparte (no dentro del .zip) | Mismo día |

**Formato del correo**

- Asunto: `SO-P04-<cuenta>-<apellido paterno>`
- Cuerpo: nombre completo, número de cuenta, grupo y una línea indicando si trabajó en el laboratorio o en casa.
- Adjuntos: el `.zip` **y** el `.log`.

---

## 3. Distribución del tiempo

| Bloque | Contenido | Minutos |
|---|---|---|
| 0 | Preparación del entorno | 3 |
| 1 | Identidad y carpeta de proyecto idempotente | 5 |
| 2 | Bitácora, variables de entorno y huella del equipo | 6 |
| 3 | Descarga y exploración del script y de los datos | 9 |
| 4 | Ejecuciones con distintos parámetros | 8 |
| 5 | Empaquetado y envío | 4 |
| | **Total** | **35** |

---

## BLOQUE 0 — Preparación del entorno (3 min)

**Abrir PowerShell:** presione `Windows + R`, escriba `powershell` y presione Enter. (Alternativa: `Windows + X` → *Windows PowerShell* / *Terminal*.)

```powershell
# Verificar la versión instalada (debe ser 5.1 o superior)
$PSVersionTable.PSVersion

# Permitir la ejecución de scripts SOLO en esta ventana de consola.
# Al cerrar PowerShell, el permiso desaparece: no se altera la configuración del equipo.
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
```

> **¿Por qué `-Scope Process`?** Porque un administrador responsable no baja las defensas de una máquina completa para resolver una tarea de cinco minutos. El alcance `Process` afecta únicamente a la ventana actual. Es el principio de **privilegio mínimo** aplicado a la vida diaria.

---

## BLOQUE 1 — Identidad y carpeta de proyecto idempotente (5 min)

### Paso 1.1 — Registre su identidad en variables

Edite los dos valores con **sus** datos reales antes de ejecutar.

```powershell
$Estudiante = 'Nombre Apellido Apellido'   # <-- CAMBIE ESTO
$Cuenta     = '0000000'                    # <-- CAMBIE ESTO
```

### Paso 1.2 — Localizar el Escritorio de forma portable

No escriba nunca `C:\Users\Juan\Desktop` a mano. Esa ruta cambia según el usuario, según el idioma de Windows (`Desktop` / `Escritorio`) y según si el equipo tiene OneDrive redirigiendo las carpetas. Pregúntele al sistema operativo dónde está:

```powershell
# Windows responde con la ruta real del Escritorio de ESTE usuario, en ESTE equipo
$Escritorio = [Environment]::GetFolderPath('Desktop')

# Plan de respaldo por si el valor llegara vacío
if ([string]::IsNullOrWhiteSpace($Escritorio) -or -not (Test-Path -LiteralPath $Escritorio)) {
    $Escritorio = Join-Path -Path $env:USERPROFILE -ChildPath 'Desktop'
}

$Escritorio   # muestre en pantalla la ruta obtenida
```

> **Lectura profesional:** esto se llama *portabilidad*. Un procedimiento que solo funciona en la máquina de quien lo escribió no es un procedimiento; es una casualidad.

### Paso 1.3 — Crear la carpeta del proyecto (de forma idempotente)

```powershell
$Proyecto = Join-Path -Path $Escritorio -ChildPath ("P04_TopPeliculas_{0}" -f $Cuenta)

if (-not (Test-Path -LiteralPath $Proyecto)) {
    New-Item -ItemType Directory -Path $Proyecto -Force | Out-Null
    Write-Host "Carpeta creada: $Proyecto" -ForegroundColor Green
} else {
    Write-Host "La carpeta ya existia, se reutiliza: $Proyecto" -ForegroundColor Yellow
}
```

**Ejecute el bloque anterior DOS veces seguidas** y observe el cambio de mensaje. No hay error rojo en ninguna de las dos: eso es idempotencia.

### Paso 1.4 — Entrar a la carpeta (`cd`)

```powershell
# Forma corta (cd es un alias de Set-Location)
cd "$Proyecto"

# Forma explícita y recomendada en scripts (soporta rutas con espacios y caracteres raros)
Set-Location -LiteralPath $Proyecto

# Confirmar dónde estamos parados
Get-Location
```

### ✍️ Actividad 1 (se entrega por escrito)

1. Escriba **la ruta completa** que devolvió `$Escritorio` en su equipo.
2. Explique en una o dos líneas por qué esa ruta podría ser distinta en la computadora de otra persona del grupo.
3. ¿Qué mensaje apareció la **segunda** vez que ejecutó el bloque del Paso 1.3 y qué demuestra eso?

---

## BLOQUE 2 — Bitácora, variables de entorno y huella del equipo (6 min)

### Paso 2.1 — Iniciar la bitácora

`Start-Transcript` graba en un archivo **todo** lo que ocurra en la consola desde este momento: comandos, resultados, advertencias y errores.

```powershell
$Bitacora = Join-Path -Path $Escritorio -ChildPath ("Bitacora_P04_{0}.log" -f $Cuenta)

# -Force sobrescribe la bitácora anterior: si repite la práctica, no acumula archivos sueltos
Start-Transcript -Path $Bitacora -Force
```

### Paso 2.2 — Registrar identidad y variables de entorno

```powershell
Write-Output "===== IDENTIDAD DEL ESTUDIANTE ====="
Write-Output "Estudiante : $Estudiante"
Write-Output "Cuenta     : $Cuenta"
Write-Output "Fecha      : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Write-Output "===== VARIABLES DE ENTORNO ====="
Get-ChildItem Env: |
    Where-Object { $_.Name -in @('USERNAME','USERDOMAIN','COMPUTERNAME','USERPROFILE',
                                 'OS','PROCESSOR_ARCHITECTURE','NUMBER_OF_PROCESSORS','SystemRoot') } |
    Sort-Object Name |
    Format-Table Name, Value -AutoSize
```

> **¿Qué es una variable de entorno?** Es información que el sistema operativo tiene lista para cualquier programa que la pida: quién inició sesión, cómo se llama el equipo, dónde está el perfil del usuario. En administración se usan constantemente para que un mismo script funcione en cientos de máquinas distintas sin modificarlo.

### Paso 2.3 — Huella del equipo: demostrar que su computadora no es la de al lado

En el laboratorio todas las máquinas son del mismo modelo. `COMPUTERNAME` ayuda, pero lo que realmente identifica un equipo físico es el **número de serie del BIOS** y el **UUID del sistema**, grabados por el fabricante.

```powershell
$CS   = Get-CimInstance -ClassName Win32_ComputerSystem
$BIOS = Get-CimInstance -ClassName Win32_BIOS
$Prod = Get-CimInstance -ClassName Win32_ComputerSystemProduct
$SO   = Get-CimInstance -ClassName Win32_OperatingSystem

$Huella = [PSCustomObject]@{
    Estudiante        = $Estudiante
    Cuenta            = $Cuenta
    Usuario           = $env:USERNAME
    NombreEquipo      = $env:COMPUTERNAME
    Fabricante        = $CS.Manufacturer
    Modelo            = $CS.Model
    NumeroSerieBIOS   = $BIOS.SerialNumber
    UUID              = $Prod.UUID
    VersionBIOS       = $BIOS.SMBIOSBIOSVersion
    SistemaOperativo  = $SO.Caption
    VersionSO         = $SO.Version
    MemoriaGB         = [math]::Round($CS.TotalPhysicalMemory / 1GB, 2)
    VersionPowerShell = $PSVersionTable.PSVersion.ToString()
    FechaHora         = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
}

# A la pantalla (y por lo tanto a la bitácora)
$Huella | Format-List

# Y también a un archivo dentro del proyecto, para que viaje dentro del .zip
$Huella | ConvertTo-Json |
    Set-Content -LiteralPath (Join-Path -Path $Proyecto -ChildPath 'Identidad_Equipo.json') -Encoding UTF8
```

> **Nota de campo:** algunos equipos ensamblados o máquinas virtuales devuelven series genéricas como `To Be Filled By O.E.M.` o `Default string`. Por eso registramos **también** el UUID, que sí suele ser único. Un inventario que depende de un solo identificador es un inventario frágil.

### ✍️ Actividad 2 (se entrega por escrito)

4. Anote el **Modelo**, el **NumeroSerieBIOS** y los **primeros 8 caracteres del UUID** de su equipo.
5. Si dos computadoras del laboratorio tienen exactamente el mismo `Modelo`, ¿qué dato de la lista permite distinguirlas y por qué?
6. Explique con sus palabras la diferencia entre `USERNAME` y `COMPUTERNAME`. ¿Cuál cambiaría si usted iniciara sesión en otra máquina del laboratorio?

---

## BLOQUE 3 — Descarga y exploración del script y de los datos (9 min)

### Paso 3.1 — Descargar el script y el archivo de datos

El script está publicado en el repositorio de la unidad de aprendizaje, carpeta `lab-04`:

https://github.com/adanestrada/fca-lia-so-26b-practicas/tree/main/lab-04

Esa dirección sirve para **verlo** en el navegador, pero no para descargarlo: devuelve la página web de GitHub, no el archivo. Para bajar el contenido real se usa la dirección `raw`, que es la que aparece en el comando siguiente. Cópiela tal cual.

```powershell
# Asegurar un protocolo de cifrado moderno (necesario en algunos equipos con Windows 10)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$UrlScript  = 'https://raw.githubusercontent.com/adanestrada/fca-lia-so-26b-practicas/refs/heads/main/lab-04/Top-Peliculas.ps1'
$RutaScript = Join-Path -Path $Proyecto -ChildPath 'Top-Peliculas.ps1'

Invoke-WebRequest -Uri $UrlScript -OutFile $RutaScript -UseBasicParsing

# Windows marca como "bloqueado" todo archivo bajado de Internet. Lo liberamos
# conscientemente porque conocemos su origen.
Unblock-File -LiteralPath $RutaScript

# Verificar que llegó completo
Get-Item -LiteralPath $RutaScript | Select-Object Name, Length, LastWriteTime
```

> **Criterio profesional:** `Unblock-File` no es un trámite; es una decisión. Se desbloquea lo que se sabe de dónde viene. Descargar y ejecutar a ciegas es la vía más común de infección en un equipo corporativo.

Ahora el **insumo**: el catálogo IMDb Top 1000, un archivo CSV con mil películas.

```powershell
$UrlDatos  = 'https://raw.githubusercontent.com/adanestrada/fca-lia-so-26b-practicas/refs/heads/main/lab-04/imdb_top_1000.csv'
$RutaDatos = Join-Path -Path $Proyecto -ChildPath 'imdb_top_1000.csv'

Invoke-WebRequest -Uri $UrlDatos -OutFile $RutaDatos -UseBasicParsing

Get-Item -LiteralPath $RutaDatos | Select-Object Name, Length, LastWriteTime
```

> El script sabe descargar este archivo por su cuenta si no lo encuentra, pero aquí lo bajamos a mano para poder **verlo antes de procesarlo**. Revisar el insumo antes de ejecutar nada es una costumbre que evita reportes elegantes construidos sobre datos equivocados.

### Paso 3.2 — Mirar los datos crudos

```powershell
# Encabezado y primeras dos filas, tal como vienen en el archivo
Get-Content .\imdb_top_1000.csv -TotalCount 3

# ¿Cuántos registros trae realmente?
(Import-Csv .\imdb_top_1000.csv | Measure-Object).Count

# Las columnas que nos interesan, ya como objetos
Import-Csv .\imdb_top_1000.csv |
    Select-Object -First 3 Series_Title, Released_Year, Runtime, Genre, IMDB_Rating, Gross |
    Format-Table -AutoSize
```

Observe tres detalles, porque explican la mitad del código del script:

- `Runtime` dice `142 min`. Es **texto**, no un número: no se puede ordenar ni sumar mientras arrastre la palabra `min`.
- `Gross` dice `28,341,469`. También es texto, por las comas de miles; y en muchas películas viene **vacío**.
- `Genre` dice `Crime, Drama` en una sola celda. Una película pertenece a varios géneros a la vez, así que filtrar por igualdad exacta contra ese texto dejaría fuera casi todo.

### Paso 3.3 — Leer la documentación del script antes de ejecutarlo

Un script bien escrito se documenta a sí mismo. Consúltelo como consultaría el manual de cualquier herramienta:

```powershell
# Ayuda completa: descripción, parámetros y ejemplos
Get-Help .\Top-Peliculas.ps1 -Full

# Solo los ejemplos de uso
Get-Help .\Top-Peliculas.ps1 -Examples
```

### Paso 3.4 — Explorar el código

```powershell
# Ver el bloque de parámetros junto con las líneas que le siguen
Select-String -Path .\Top-Peliculas.ps1 -Pattern '^\s*\[Validate' -Context 1,1

# Localizar las piezas clave y el número de línea de cada una
Select-String -Path .\Top-Peliculas.ps1 -Pattern 'param\(', 'Invoke-WebRequest', 'TryParse', 'New-Item', '-contains', 'Sort-Object', 'Select-Object -First'

# Abrirlo para leerlo con calma
notepad .\Top-Peliculas.ps1
```

Lea con atención los seis bloques comentados del archivo y responda la actividad. **Las respuestas están dentro del código: no las adivine, búsquelas.**

### ✍️ Actividad 3 — Exploración del script (se entrega por escrito)

7. ¿Cuántos registros tiene el archivo de datos? Copie el valor de `Runtime` y el de `Gross` de la primera película y explique por qué **ninguno de los dos** sirve todavía para hacer cálculos.
8. ¿Cuál es el **valor predeterminado** del parámetro `-Top` y cuáles son los **seis valores admitidos** por `-OrdenarPor`?
9. ¿Qué hace `[ValidateRange(1, 1000)]` y por qué el límite superior es precisamente 1000?
10. En el Bloque 1 del script, ¿qué ocurre si el archivo `imdb_top_1000.csv` **no está** en la carpeta? ¿Y si ya está? Explique en dos líneas por qué ese comportamiento es idempotente.
11. En el Bloque 2, ¿qué instrucción convierte el texto `142 min` en el número `142`? Cópiela textualmente.
12. En el Bloque 4, el filtro de género usa `-contains` sobre la lista `GeneroLista` y no `-eq` sobre el texto `Genero`. Tomando como ejemplo *The Godfather*, cuyo género es `Crime, Drama`, explique qué pasaría si se usara `-eq 'Drama'`.
13. ¿Cómo se construye el **nombre del archivo** de salida? Escriba el nombre completo que tendría el archivo generado por `-Top 7 -OrdenarPor Anio -Genero Drama`.

---

## BLOQUE 4 — Ejecuciones con distintos parámetros (8 min)

Ejecute las **seis** corridas en orden. Cada una genera evidencia distinta que debe viajar en el `.zip`.

```powershell
# --- Corrida 1: comportamiento PREDETERMINADO (sin banderas) ---
# Top 10 por calificación, todos los géneros, CSV
.\Top-Peliculas.ps1

# --- Corrida 2: cambiar la cantidad ---
.\Top-Peliculas.ps1 -Top 5

# --- Corrida 3: filtrar por género y cambiar el formato ---
# (los géneros vienen del archivo original, por eso están en inglés)
.\Top-Peliculas.ps1 -Top 5 -Genero Animation -Formato JSON

# --- Corrida 4: cambiar el criterio de ordenamiento ---
.\Top-Peliculas.ps1 -Top 8 -OrdenarPor Recaudacion -Formato TXT

# --- Corrida 5: invertir el orden con una bandera de tipo switch ---
# (las 5 películas MÁS CORTAS del catálogo)
.\Top-Peliculas.ps1 -Top 5 -OrdenarPor Duracion -Ascendente -Formato TXT

# --- Corrida 6: pedir más de lo que existe ---
# (el catálogo tiene menos de 25 películas del género Musical)
.\Top-Peliculas.ps1 -Top 25 -Genero Musical
```

Ahora dos comprobaciones que son el corazón de la práctica:

```powershell
# A) ¿Qué se generó?
Get-ChildItem .\salidas | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

# B) PRUEBA DE IDEMPOTENCIA: repita la corrida 2 y vuelva a listar.
.\Top-Peliculas.ps1 -Top 5
Get-ChildItem .\salidas | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

# C) PRUEBA DE VALIDACIÓN: pida un valor fuera de rango (debe aparecer un error controlado)
.\Top-Peliculas.ps1 -Top 5000

# D) PRUEBA DE VALIDACIÓN: pida un género que no existe en el archivo
.\Top-Peliculas.ps1 -Genero Terror
```

### ✍️ Actividad 4 (se entrega por escrito)

14. En la **corrida 1**, ¿cuál película quedó en la posición 1 y con qué calificación?
15. Todas las corridas imprimen un apartado **CALIDAD DE LOS DATOS DE ORIGEN**. Anote los cuatro números que reporta y explique qué problema tendría un reporte de "las más taquilleras" sabiendo cuántas películas no traen recaudación.
16. La **corrida 6** pidió 25 registros. ¿Cuántos entregó realmente y qué **advertencia** apareció en pantalla? ¿Por qué ocurrió?
17. Después de repetir la corrida 2 (prueba B), ¿aumentó el número de archivos en `salidas`? ¿Qué cambió entonces en el listado? Relacione su respuesta con el concepto de idempotencia.
18. Transcriba los mensajes de error de las pruebas C y D. Explique por qué es **mejor** que el script rechace esos valores a que intente ejecutarse de todos modos.
19. Mencione una tarea real de un área de sistemas (inventarios, respaldos, reportes, altas de usuarios) donde convenga que el proceso sea idempotente. Justifique en dos líneas.

---

## BLOQUE 5 — Empaquetado, cierre de bitácora y envío (4 min)

```powershell
# 1) Empaquetar el proyecto: script, identidad del equipo y salidas.
#    Se excluye el archivo de datos de origen: pesa mucho, es idéntico para
#    todo el grupo y no es un resultado del trabajo de nadie.
$Zip = Join-Path -Path $Escritorio -ChildPath ("P04_TopPeliculas_{0}.zip" -f $Cuenta)
$Contenido = Get-ChildItem -LiteralPath $Proyecto -Exclude 'imdb_top_1000.csv'
Compress-Archive -Path $Contenido.FullName -DestinationPath $Zip -Force

# 2) Verificar el paquete
Get-Item -LiteralPath $Zip | Select-Object Name, Length, LastWriteTime

# 3) Cerrar la bitácora (SIEMPRE al final)
Stop-Transcript
```

> `-Force` en `Compress-Archive` reemplaza el `.zip` anterior en lugar de fallar. Mismo criterio de idempotencia: repetir la práctica no debe llenar el Escritorio de archivos `(1)`, `(2)`, `(3)`.

**En su Escritorio deben quedar exactamente estos elementos:**

```
Escritorio\
├── P04_TopPeliculas_<cuenta>\        (carpeta de trabajo)
│   ├── Top-Peliculas.ps1
│   ├── imdb_top_1000.csv             (insumo: NO se envía)
│   ├── Identidad_Equipo.json
│   └── salidas\  (6 archivos: CSV, JSON y TXT)
├── P04_TopPeliculas_<cuenta>.zip     → se envía por correo
└── Bitacora_P04_<cuenta>.log         → se envía por correo, por separado
```

### ✍️ Actividad 5 (se entrega por escrito)

20. Liste los **nombres de los archivos** que quedaron dentro de la carpeta `salidas`.
21. ¿Por qué el profesor pide la bitácora **además** del `.zip`? ¿Qué información contiene la bitácora que los archivos de salida no pueden demostrar por sí solos?

---

## Anexo A — Hoja de respuestas (copiar a mano y entregar al profesor)

Escriba a mano en una hoja tamaño carta. Encabezado obligatorio:

```
Nombre completo: ______________________________  Cuenta: ____________
Fecha: __________
```

Numere las respuestas del **1 al 21** siguiendo el orden de las actividades. Respuestas breves y concretas; se califica la comprensión, no la extensión.

| Bloque | Preguntas |
|---|---|
| 1 — Carpeta portable e idempotente | 1, 2, 3 |
| 2 — Identidad y huella del equipo | 4, 5, 6 |
| 3 — Datos crudos y exploración del script | 7, 8, 9, 10, 11, 12, 13 |
| 4 — Ejecuciones y parámetros | 14, 15, 16, 17, 18, 19 |
| 5 — Entregables | 20, 21 |

**Entrega:** al finalizar la sesión, en mano, antes de salir del aula. Sin la hoja no se registra la práctica, aunque el correo haya sido enviado.

---

## Anexo B — Solución de problemas frecuentes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `No se puede cargar el archivo ... no está firmado digitalmente` | Directiva de ejecución restringida | Repita `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force` |
| `El término '.\Top-Peliculas.ps1' no se reconoce` | No está posicionado en la carpeta del proyecto | `Set-Location -LiteralPath $Proyecto` y verifique con `Get-Location` |
| `Invoke-WebRequest : No se puede resolver el host` | Sin conexión o URL mal copiada | Verifique la URL; si no hay red, solicite el archivo por USB y cópielo a la carpeta del proyecto |
| `Invoke-WebRequest : (404) No encontrado` | Se usó la dirección de la página de GitHub (`/tree/`) en vez de la dirección `raw` | Copie exactamente la URL que empieza con `raw.githubusercontent.com` del Paso 3.1 |
| El archivo se descarga pero pesa muy poco y no ejecuta | Se guardó una página HTML en lugar del script | Ábralo con `notepad`; si contiene etiquetas HTML, repita la descarga con la URL `raw` |
| `Import-Csv : No se encuentra la ruta ... imdb_top_1000.csv` | El archivo de datos no se descargó | Repita el Paso 3.1; si no hay red, copie el CSV por USB y ejecute el script con `-RutaDatos 'D:\imdb_top_1000.csv'` |
| El reporte sale con `RecaudacionMDD` en 0 | Esas películas no traen el dato en el archivo de origen | Es correcto: el script lo reporta en el apartado de calidad de datos. No es un error del script |
| `No se puede validar el argumento del parámetro 'Genero'` | Se escribió el género en español o mal escrito | Use los nombres tal como vienen en el archivo: `Drama`, `Crime`, `Animation`, `Sci-Fi`, `Musical`... |
| Las variables `$Proyecto` o `$Escritorio` aparecen vacías | Cerró y volvió a abrir PowerShell (las variables viven solo en la sesión) | Vuelva a ejecutar los Pasos 1.1 a 1.3 |
| `NumeroSerieBIOS` dice `Default string` | Equipo ensamblado o máquina virtual | Es normal; reporte el UUID y anótelo en la hoja |
| Los acentos se ven mal en los archivos `.txt` | Diferencia de codificación entre consola y editor | Ábralos con VS Code o Bloc de notas seleccionando UTF-8; no afecta la calificación |
| `Stop-Transcript` marca que no hay transcripción activa | Nunca se ejecutó `Start-Transcript` o ya se cerró | Vuelva a ejecutar el Bloque 2 completo |

---

## Anexo C — Rúbrica de evaluación (100 puntos)

| Criterio | Evidencia | Puntos |
|---|---|---|
| Carpeta e identidad correctas y portables | `Identidad_Equipo.json` dentro del `.zip` | 15 |
| Bitácora completa (inicio, variables, huella, ejecuciones, cierre) | `Bitacora_P04_<cuenta>.log` | 20 |
| Las seis corridas ejecutadas y sus salidas presentes | Contenido de `salidas` en el `.zip` | 20 |
| Comprensión del archivo de datos y del script (preguntas 7 a 13) | Hoja de respuestas | 25 |
| Razonamiento sobre calidad de datos, idempotencia y validación (15 a 19) | Hoja de respuestas | 15 |
| Entrega en tiempo y forma (asunto del correo, adjuntos completos) | Correo electrónico | 5 |

---

## Anexo D — Fuentes de consulta

Documentación oficial y bibliografía de referencia consultadas para el diseño de esta práctica. Se recomienda al estudiantado revisar al menos las tres primeras.

**Documentación oficial de Microsoft (fuente primaria)**

1. *What is PowerShell?* — Microsoft Learn
   https://learn.microsoft.com/en-us/powershell/scripting/overview
2. *PowerShell 101* (basado en el libro de Mike F. Robbins) — Microsoft Learn
   https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/00-introduction
3. *about_Scripts* — Microsoft Learn
   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts
4. *about_Functions_Advanced_Parameters* (atributos `ValidateSet`, `ValidateRange`, parámetros `switch`)
   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters
5. *about_Comment_Based_Help* (documentación interna de scripts y `Get-Help`)
   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help
6. *about_Execution_Policies* (directivas de ejecución y alcances)
   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies
7. *Start-Transcript* — registro de sesión
   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.host/start-transcript
8. *Get-CimInstance* — consulta de información del sistema mediante CIM/WMI
   https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance
9. *Win32_BIOS class* (propiedad `SerialNumber`)
   https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-bios
10. *Win32_ComputerSystem class* (fabricante, modelo, memoria)
    https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem
11. *Win32_ComputerSystemProduct class* (UUID del sistema)
    https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystemproduct
12. *Environment.GetFolderPath Method* — resolución portable de carpetas especiales
    https://learn.microsoft.com/en-us/dotnet/api/system.environment.getfolderpath
13. *Import-Csv* — lectura de archivos CSV como objetos
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-csv
14. *about_Comparison_Operators* (operador `-contains`, usado para filtrar géneros múltiples)
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators
15. *Int32.TryParse Method* — conversión segura de texto a número, sin detener la ejecución
    https://learn.microsoft.com/en-us/dotnet/api/system.int32.tryparse
16. *Compress-Archive* — empaquetado de entregables
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive
17. *Invoke-WebRequest* / *Unblock-File*
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/unblock-file

**Conjunto de datos utilizado**

18. Shankhdhar, H. (2021). *IMDB Movies Dataset — Top 1000 Movies by IMDB Rating*. Kaggle.
    https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows
19. Copia utilizada en clase (archivo `imdb_top_1000.csv`), alojada en el repositorio de la unidad de aprendizaje:
    https://raw.githubusercontent.com/adanestrada/fca-lia-so-26b-practicas/refs/heads/main/lab-04/imdb_top_1000.csv

**Fundamento del concepto de idempotencia y automatización**

20. Humble, J. y Farley, D. (2010). *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley. (Capítulo sobre gestión de configuración y despliegues repetibles.)
21. Limoncelli, T., Chalup, S. y Hogan, C. (2016). *The Practice of System and Network Administration* (3.ª ed.). Addison-Wesley. (Automatización, inventarios y procedimientos reproducibles.)
22. Red Hat. *Ansible — Desired State and Idempotency*, documentación oficial de conceptos.
    https://docs.ansible.com/ansible/latest/getting_started/basic_concepts.html
23. Robbins, M. F. (2017). *PowerShell 101: The No-Nonsense Guide to Windows PowerShell*. Leanpub.

**Sistemas operativos (marco teórico de la unidad de aprendizaje)**

24. Silberschatz, A., Galvin, P. B. y Gagne, G. (2018). *Operating System Concepts* (10.ª ed.). Wiley. (Intérpretes de comandos, procesos y entorno de ejecución.)
25. Tanenbaum, A. S. y Bos, H. (2015). *Modern Operating Systems* (4.ª ed.). Pearson. (Interfaz del sistema operativo y shells.)

> *Fechas de consulta: agosto de 2026. Los enlaces de Microsoft Learn permiten cambiar el idioma a español desde el selector de la propia página.*
