<#
.SYNOPSIS
    Genera un reporte "Top N" a partir del catalogo IMDb Top 1000 (archivo CSV).

.DESCRIPTION
    Practica 04 - Sistemas Operativos / Informatica Administrativa.

    Este script automatiza el mismo proceso que antes se hizo comando por
    comando: leer un archivo de datos, limpiarlo, filtrarlo, ordenarlo,
    recortarlo a los primeros N registros y exportarlo.

    Trabaja sobre un archivo REAL (imdb_top_1000.csv, 1000 peliculas), no sobre
    datos de laboratorio. Por eso incluye un bloque de LIMPIEZA: el archivo trae
    la duracion como texto ("142 min"), la recaudacion con comas ("28,341,469"),
    campos vacios y hasta un anio invalido. Un administrador informatico casi
    nunca recibe datos limpios.

    El script es IDEMPOTENTE: puede ejecutarse muchas veces con los mismos
    parametros y el resultado sera siempre el mismo. La carpeta de salida se
    crea solo si no existe, el archivo de datos se descarga solo si falta y los
    reportes se sobrescriben en lugar de duplicarse.

    Comportamiento predeterminado (sin banderas ni parametros):
        Top 10 de peliculas ordenadas por CALIFICACION, de mayor a menor,
        de todos los generos, exportado en formato CSV a la subcarpeta "salidas".

.PARAMETER Top
    Cantidad de peliculas a incluir en el reporte. Valor predeterminado: 10.
    Se aceptan valores entre 1 y 1000 (tamano del catalogo).

.PARAMETER OrdenarPor
    Criterio de ordenamiento. Valores admitidos:
    Calificacion (predeterminado), Recaudacion, Anio, Duracion, Votos, Metascore.

.PARAMETER Genero
    Filtro por genero. "Todos" (predeterminado) no filtra. Cada pelicula puede
    tener varios generos: el filtro busca coincidencia exacta dentro de esa lista.

.PARAMETER Formato
    Formato del archivo de salida: CSV (predeterminado), JSON o TXT.

.PARAMETER RutaDatos
    Ruta del archivo imdb_top_1000.csv. Si se omite, se busca junto al script.
    Si no existe, se descarga automaticamente.

.PARAMETER UrlDatos
    Direccion de descarga del archivo de datos cuando este no se encuentra.

.PARAMETER RutaSalida
    Carpeta donde se depositan los reportes. Si se omite, se usa la subcarpeta
    "salidas" dentro de la carpeta donde vive este script.

.PARAMETER Ascendente
    Bandera de tipo switch (no recibe valor). Invierte el ordenamiento:
    de menor a mayor en lugar de mayor a menor.

.PARAMETER ActualizarDatos
    Bandera de tipo switch. Vuelve a descargar el archivo de datos aunque ya
    exista en el disco.

.EXAMPLE
    .\Top-Peliculas.ps1
    Ejecucion predeterminada: Top 10 por calificacion, todos los generos, CSV.

.EXAMPLE
    .\Top-Peliculas.ps1 -Top 5
    Top 5 por calificacion, todos los generos, CSV.

.EXAMPLE
    .\Top-Peliculas.ps1 -Top 5 -Genero Animation -Formato JSON
    Top 5 de peliculas animadas, exportado como JSON.

.EXAMPLE
    .\Top-Peliculas.ps1 -Top 8 -OrdenarPor Recaudacion -Formato TXT
    Las 8 peliculas mas taquilleras, en tabla de texto plano.

.EXAMPLE
    .\Top-Peliculas.ps1 -Top 5 -OrdenarPor Duracion -Ascendente -Formato TXT
    Las 5 peliculas MAS CORTAS del catalogo.

.NOTES
    Autor  : Academia de Sistemas Operativos
    Version: 2.0
    Datos  : IMDb Top 1000 (conjunto de datos publico, uso didactico).
#>


#Requires -Version 5.1

[CmdletBinding()]
param(
    # --- Parametro 1: cuantos registros quiero ---
    [ValidateRange(1, 1000)]
    [int]$Top = 10,

    # --- Parametro 2: por cual columna ordeno ---
    [ValidateSet('Calificacion', 'Recaudacion', 'Anio', 'Duracion', 'Votos', 'Metascore')]
    [string]$OrdenarPor = 'Calificacion',

    # --- Parametro 3: filtro por genero (lista tomada del propio archivo) ---
    [ValidateSet('Todos', 'Action', 'Adventure', 'Animation', 'Biography', 'Comedy',
                 'Crime', 'Drama', 'Family', 'Fantasy', 'Film-Noir', 'History',
                 'Horror', 'Music', 'Musical', 'Mystery', 'Romance', 'Sci-Fi',
                 'Sport', 'Thriller', 'War', 'Western')]
    [string]$Genero = 'Todos',

    # --- Parametro 4: formato del archivo generado ---
    [ValidateSet('CSV', 'JSON', 'TXT')]
    [string]$Formato = 'CSV',

    # --- Parametro 5: de donde leo los datos ---
    [string]$RutaDatos,

    # --- Parametro 6: de donde los descargo si faltan ---
    [string]$UrlDatos = 'https://raw.githubusercontent.com/adanestrada/fca-lia-so-26b-practicas/refs/heads/main/lab-04/imdb_top_1000.csv',

    # --- Parametro 7: donde dejo los archivos ---
    [string]$RutaSalida,

    # --- Parametros 8 y 9: banderas de tipo switch (presente = verdadero) ---
    [switch]$Ascendente,

    [switch]$ActualizarDatos
)

# Si algo falla, detener la ejecucion en lugar de continuar con datos a medias.
$ErrorActionPreference = 'Stop'

# Carpeta base: donde vive este script.
$Base = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# =====================================================================
# BLOQUE 1. OBTENER EL ARCHIVO DE DATOS (parte idempotente)
#           Se descarga UNICAMENTE si no esta en el disco.
# =====================================================================

if ([string]::IsNullOrWhiteSpace($RutaDatos)) {
    $RutaDatos = Join-Path -Path $Base -ChildPath 'imdb_top_1000.csv'
}

if ((Test-Path -LiteralPath $RutaDatos) -and (-not $ActualizarDatos.IsPresent)) {
    Write-Verbose "El archivo de datos ya existe, se reutiliza: $RutaDatos"
}
else {
    Write-Host 'Descargando el archivo de datos...' -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $UrlDatos -OutFile $RutaDatos -UseBasicParsing
        Write-Host "Archivo de datos guardado en: $RutaDatos" -ForegroundColor Cyan
    }
    catch {
        throw "No se pudo descargar el archivo de datos desde '$UrlDatos'. Descarguelo manualmente y vuelva a ejecutar el script usando -RutaDatos. Detalle: $($_.Exception.Message)"
    }
}

# =====================================================================
# BLOQUE 2. LEER Y LIMPIAR
#           El archivo original NO viene listo para calcular:
#             Runtime       -> "142 min"      (texto con unidad)
#             Gross         -> "28,341,469"   (texto con separadores de miles)
#             Released_Year -> a veces no es un numero
#             Meta_score    -> a veces viene vacio
#             Genre         -> varios generos en una sola celda
# =====================================================================

$Crudo = Import-Csv -LiteralPath $RutaDatos -Encoding UTF8

$SinRecaudacion = 0
$SinMetascore   = 0
$AnioInvalido   = 0

$Catalogo = foreach ($fila in $Crudo) {

    # Anio: convertir a numero; si no se puede, queda en 0 y se contabiliza.
    $anio = 0
    if (-not [int]::TryParse($fila.Released_Year, [ref]$anio)) { $AnioInvalido++ }

    # Duracion: quitar todo lo que no sea digito ("142 min" -> 142).
    $duracion = 0
    [void][int]::TryParse(($fila.Runtime -replace '[^\d]', ''), [ref]$duracion)

    # Recaudacion: quitar comas y convertir despues a millones de dolares.
    $bruto = 0.0
    $textoGross = ($fila.Gross -replace '[^\d]', '')
    if ([string]::IsNullOrWhiteSpace($textoGross)) { $SinRecaudacion++ }
    else { [void][double]::TryParse($textoGross, [ref]$bruto) }

    # Metascore: puede venir vacio.
    $meta = 0
    if (-not [int]::TryParse($fila.Meta_score, [ref]$meta)) { $SinMetascore++ }

    # Votos.
    $votos = 0
    [void][int]::TryParse(($fila.No_of_Votes -replace '[^\d]', ''), [ref]$votos)

    # Calificacion.
    $calif = 0.0
    [void][double]::TryParse($fila.IMDB_Rating, [ref]$calif)

    [PSCustomObject]@{
        Titulo       = $fila.Series_Title
        Anio         = $anio
        Genero       = $fila.Genre
        # Lista de generos separada, para poder filtrar con precision:
        # "Action, Crime, Drama" -> @('Action','Crime','Drama')
        GeneroLista  = @($fila.Genre -split ',' | ForEach-Object { $_.Trim() })
        Calificacion = $calif
        Metascore    = $meta
        Recaudacion  = [math]::Round($bruto / 1000000, 2)   # en millones de dolares
        Duracion     = $duracion
        Votos        = $votos
        Director     = $fila.Director
    }
}

$TotalLeidos = @($Catalogo).Count

# =====================================================================
# BLOQUE 3. PREPARAR EL DESTINO (parte idempotente)
# =====================================================================

if ([string]::IsNullOrWhiteSpace($RutaSalida)) {
    $RutaSalida = Join-Path -Path $Base -ChildPath 'salidas'
}

# New-Item con -Force crea la carpeta si no existe y NO marca error si ya
# existe. Esa es la esencia de una operacion idempotente.
if (-not (Test-Path -LiteralPath $RutaSalida)) {
    New-Item -ItemType Directory -Path $RutaSalida -Force | Out-Null
    Write-Verbose "Carpeta de salida creada: $RutaSalida"
}
else {
    Write-Verbose "La carpeta de salida ya existia, se reutiliza: $RutaSalida"
}

# =====================================================================
# BLOQUE 4. FILTRAR, ORDENAR Y RECORTAR
# =====================================================================

# Una pelicula puede pertenecer a varios generos a la vez. Por eso se usa
# -contains sobre la lista y no una comparacion de igualdad contra el texto.
$Datos = if ($Genero -eq 'Todos') {
    $Catalogo
}
else {
    $Catalogo | Where-Object { $_.GeneroLista -contains $Genero }
}

# La bandera -Ascendente invierte el sentido del ordenamiento.
$OrdenDescendente = -not $Ascendente.IsPresent

$Seleccion = $Datos |
    Sort-Object -Property $OrdenarPor -Descending:$OrdenDescendente |
    Select-Object -First $Top

# Agregamos la columna Posicion (1, 2, 3...) para que el reporte se lea mejor.
$posicion = 0
$Reporte = $Seleccion | ForEach-Object {
    $posicion++
    [PSCustomObject]@{
        Posicion       = $posicion
        Titulo         = $_.Titulo
        Anio           = $_.Anio
        Genero         = $_.Genero
        Calificacion   = $_.Calificacion
        Metascore      = $_.Metascore
        RecaudacionMDD = $_.Recaudacion
        DuracionMin    = $_.Duracion
        Votos          = $_.Votos
        Director       = $_.Director
    }
}

$Encontrados = @($Reporte).Count

# =====================================================================
# BLOQUE 5. NOMBRE DEL ARCHIVO Y EXPORTACION
# =====================================================================

# El nombre se arma con los parametros usados. Consecuencia: dos ejecuciones
# con los MISMOS parametros escriben el MISMO archivo (se sobrescribe, no se
# duplica); dos ejecuciones con parametros distintos generan archivos distintos.
$Sentido    = if ($Ascendente.IsPresent) { 'Asc' } else { 'Desc' }
$NombreBase = 'Top{0:D3}_{1}_{2}_{3}' -f $Top, $OrdenarPor, $Genero, $Sentido
$Extension  = $Formato.ToLower()
$Archivo    = Join-Path -Path $RutaSalida -ChildPath "$NombreBase.$Extension"

switch ($Formato) {
    'CSV' {
        $Reporte | Export-Csv -LiteralPath $Archivo -NoTypeInformation -Encoding UTF8
    }
    'JSON' {
        $Reporte | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $Archivo -Encoding UTF8
    }
    'TXT' {
        $Reporte |
            Format-Table -AutoSize |
            Out-String -Width 250 |
            Set-Content -LiteralPath $Archivo -Encoding UTF8
    }
}

# =====================================================================
# BLOQUE 6. INFORME EN PANTALLA (queda registrado en la bitacora)
# =====================================================================

Write-Host ''
Write-Host '===============================================================' -ForegroundColor DarkGreen
Write-Host ' REPORTE TOP-N DE PELICULAS  |  Practica 04 - Sistemas Operativos' -ForegroundColor DarkGreen
Write-Host '===============================================================' -ForegroundColor DarkGreen
Write-Host (' Fecha y hora   : {0}' -f (Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))
Write-Host (' Equipo         : {0}' -f $env:COMPUTERNAME)
Write-Host (' Usuario        : {0}' -f $env:USERNAME)
Write-Host (' Archivo datos  : {0}' -f $RutaDatos)
Write-Host (' Parametro Top  : {0}' -f $Top)
Write-Host (' Ordenar por    : {0} ({1})' -f $OrdenarPor, $(if ($Ascendente.IsPresent) { 'ascendente' } else { 'descendente' }))
Write-Host (' Genero         : {0}' -f $Genero)
Write-Host (' Formato        : {0}' -f $Formato)
Write-Host (' Registros      : {0}' -f $Encontrados)
Write-Host (' Archivo salida : {0}' -f $Archivo)
Write-Host '--------------- CALIDAD DE LOS DATOS DE ORIGEN ----------------'
Write-Host (' Registros leidos        : {0}' -f $TotalLeidos)
Write-Host (' Sin dato de recaudacion : {0}' -f $SinRecaudacion)
Write-Host (' Sin dato de metascore   : {0}' -f $SinMetascore)
Write-Host (' Con anio no numerico    : {0}' -f $AnioInvalido)
Write-Host '---------------------------------------------------------------'

$Reporte | Format-Table -AutoSize | Out-String -Width 250 | Write-Host

if ($Encontrados -lt $Top) {
    Write-Warning ("Se pidieron {0} registros pero el filtro '{1}' solo tiene {2}. Se entrega lo disponible." -f $Top, $Genero, $Encontrados)
}

if ($OrdenarPor -eq 'Recaudacion' -and $SinRecaudacion -gt 0) {
    Write-Warning ("{0} peliculas no traen recaudacion en el archivo de origen y se tratan como 0. Considerelo al interpretar el reporte." -f $SinRecaudacion)
}

Write-Host 'Ejecucion terminada correctamente.' -ForegroundColor DarkGreen
Write-Host ''
