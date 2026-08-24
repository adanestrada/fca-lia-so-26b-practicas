# Resumen — Práctica Guiada de PowerShell · `lab_03_IMDb` (UAEMEX)

> Este documento es un **resumen rápido** de la práctica. Para las pistas, banderas y salidas esperadas de cada paso, consulta el documento completo `Practica_PowerShell_IMDb_UAEMEX.pdf`.

---

## 1. Contexto de negocio

El equipo de Distribución de Contenidos necesita saber qué 10 películas requieren más **réplicas** (formatos 4K, HD, SD, Móvil) según su demanda (votos en IMDb). Tu misión: usar PowerShell para obtener el **Top 10 de películas con más votos** a partir de un catálogo de 1000 películas, y entregar un reporte en CSV.

---

## 2. Antes de empezar (Paso 0): identidad, bitácora y tu libreta de comandos

### 2.1 Declara tu identidad

```powershell
$env:NOMBRE_APELLIDOS = "NOMBRE_APELLIDO1_APELLIDO2"
$env:NUM_CUENTA = "12345678"
```
Sustituye por tus datos reales. Ejecútalo cada vez que abras una nueva terminal.

### 2.2 Resuelve el Escritorio de forma portable

```powershell
$logDir = [Environment]::GetFolderPath('Desktop')
if (-not $logDir -or -not (Test-Path -LiteralPath $logDir)) {
    $logDir = $PWD.Path
}
```

### 2.3 Inicia tu bitácora de evidencia

```powershell
$logPath = Join-Path $logDir "practica_SO_$env:NUM_CUENTA.log"
Start-Transcript -Path $logPath
```
A partir de aquí, todo lo que escribas y toda la salida en pantalla queda grabada en tu `.log`.

### 2.4 Crea tu "libreta" de comandos: `script.ps1` (recomendado)

Además de la bitácora (que es solo un registro de lo que ya ejecutaste), te conviene llevar un **borrador editable** de tus comandos:

1. Abre el **Bloc de notas** y guarda un archivo vacío en tu **Escritorio** con el nombre exacto `script.ps1`.
2. Conforme vayas descubriendo/armando el comando correcto de cada paso (Pasos 1 a 10), **cópialo y pégalo en `script.ps1`**, en orden, uno debajo del otro. No hace falta ejecutarlo ahí — el Bloc de notas solo lo está guardando.
3. Este archivo es lo que te permite **pausar la práctica y retomarla en la siguiente clase** sin perder tu avance: la próxima sesión, abres `script.ps1`, revisas dónde te quedaste y continúas.
4. **No ejecutes los comandos de uno en uno directamente desde `script.ps1`.** La idea es que, hasta que tengas armada y revisada tu secuencia completa (del Paso 1 al Paso 10), selecciones todo el contenido de `script.ps1` y lo pegues de una sola vez en la consola de PowerShell para ejecutarlo de principio a fin.
5. Si al ejecutar todo junto algo falla o necesitas ajustar una línea, **haz la prueba y el ajuste directamente en la consola de PowerShell** (no en el Bloc de notas), y solo cuando ya te funcione, actualiza esa línea en tu `script.ps1` para dejarla corregida.

> `script.ps1` = tu borrador de trabajo (editable, se corrige libremente).
> `practica_SO_<cuenta>.log` = tu evidencia (se genera sola al ejecutar, con `Start-Transcript`/`Stop-Transcript`).

---

## 3. Ruta de trabajo (referencia rápida de los pasos)

| Paso | Qué hace | Cmdlet(s) clave |
|---|---|---|
| 0 | Identidad + Escritorio portable + iniciar bitácora | `Start-Transcript`, `[Environment]::GetFolderPath` |
| 1 | Crear la carpeta `lab_03_IMDb` en el Escritorio | `New-Item`, `Join-Path` |
| 2 | Descargar el CSV del catálogo | `Invoke-WebRequest` |
| 3 | Confirmar que la descarga fue exitosa | `Test-Path`, `Get-Item` |
| 4 | Importar el CSV como tabla de datos | `Import-Csv` |
| 5 | Explorar las columnas disponibles | `Get-Member` |
| 6 | Ordenar por número de votos (¡cuidado, son texto!) | `Sort-Object` |
| 7 | Quedarse con el Top 10 | `Select-Object -First` |
| 8 | Quedarse solo con las columnas del reporte | `Select-Object -Property` |
| 9 | Exportar el reporte final | `Export-Csv` |
| 10 | Comprimir el entregable | `Compress-Archive` |
| 11 | Detener la bitácora | `Stop-Transcript` |

---

## 4. Entrega de la práctica

La entrega tiene **dos partes independientes**:

### 4.1 Evidencia digital (por correo al profesor)
Adjunta dos archivos:
1. El **.zip** del proyecto (Paso 10).
2. El **.log** de tu bitácora (Paso 0 / Paso 11), nombrado `practica_SO_<tu número de cuenta>.log`.

Antes de enviar: confirma que ejecutaste `Stop-Transcript`. Sugerencia de asunto: *"Práctica PowerShell IMDb — \<Nombre Apellidos> — \<Número de cuenta>"*.

### 4.2 Cuestionario de reflexión (entrega en papel, a mano)

Responde **a mano**, en una hoja, las siguientes 7 preguntas y entrégala al profesor. **Escribe únicamente las respuestas** (numeradas del 1 al 7), no es necesario copiar las preguntas.

**Preguntas de confirmación (usa PowerShell o el Explorador de archivos para verificar tu respuesta):**

1. ¿Cuál es el tamaño (en KB) de tu archivo `Top10_Replicas.csv`?
   - Pista CLI: `(Get-Item .\Top10_Replicas.csv).Length`
   - Pista GUI: Explorador de archivos → clic derecho sobre el archivo → *Propiedades* → *Tamaño*.

2. ¿Cuál es el tamaño (en KB) de tu archivo comprimido `Top10_Replicas.zip`? ¿Es mayor o menor que el del CSV original?
   - Pista CLI: `(Get-Item .\Top10_Replicas.zip).Length`
   - Pista GUI: Explorador de archivos → vista de detalle → columna *Tamaño*.

3. ¿En qué fecha y hora se modificó por última vez tu archivo de bitácora (`.log`)?
   - Pista CLI: `(Get-Item .\practica_SO_<tu_cuenta>.log).LastWriteTime`
   - Pista GUI: Explorador de archivos → columna *Fecha de modificación* (o *Propiedades* → *Detalles*).

**Preguntas de reflexión (sin usar la línea de comandos):**

4. Si hubieras tenido que ordenar manualmente (por ejemplo, a mano o copiando y pegando en una hoja de cálculo) las 1000 películas por número de votos para encontrar las 10 con más votos, ¿cuánto tiempo estimas que te habría tomado? Compáralo con lo que tardaste usando PowerShell.

5. Si no hubieras usado PowerShell, ¿qué otra herramienta habrías usado para resolver este mismo reto (ordenar, filtrar y exportar el Top 10)? Menciónala.

6. La herramienta que mencionaste en la pregunta anterior, ¿se puede automatizar para que se ejecute sola (por ejemplo, todos los lunes) sin que tú la operes manualmente cada vez? Explica brevemente por qué sí o por qué no.

7. Si en lugar de 1000 películas el catálogo tuviera varios millones de registros, ¿qué esperarías que pasara con el método manual o con la herramienta de la pregunta 5, en comparación con seguir usando PowerShell? ¿Por qué?

---
*Resumen elaborado como material de apoyo de la Práctica Guiada de PowerShell — UAEMEX.*
