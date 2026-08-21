# Práctica: Anatomía de un Comando (PowerShell)

Práctica de laboratorio para el tema **Interfaz de Línea de Comandos en Windows**, basada en la Diapositiva 12 · Anatomía de un comando.

## Archivo principal

`Practica_Anatomia_de_un_Comando_PowerShell.md`

## ¿De qué trata?

El alumno aprende a descomponer un comando de PowerShell en sus 4 partes:

1. **Prompt** — ruta actual, ej. `PS C:\Users\Estudiante>`
2. **Comando** — el cmdlet, ej. `Get-ChildItem`
3. **Opciones/Banderas** — parámetros que inician con `-`, ej. `-Path`, `-Recurse`
4. **Argumentos** — los valores sobre los que actúa el comando, ej. `C:\Windows`

## Cómo usar la práctica

1. Abrir PowerShell en Windows.
2. Leer el marco conceptual y los **3 ejemplos resueltos**.
3. Resolver los **10 ejercicios**, cada uno con:
   - Presentación del comando
   - Ejemplo de uso
   - Cómo pedir ayuda con `Get-Help`
   - Comando a analizar
   - Tabla en blanco para entregar la descomposición (Prompt / Comando / Opciones-Banderas / Argumentos)
4. (Opcional) Ejecutar cada comando en la terminal para comprobar el resultado.
5. Entregar la hoja con las 10 tablas completas.

## Comandos cubiertos

`Get-Location`, `Set-Location`, `Get-ChildItem`, `New-Item`, `Add-Content`, `Get-Content`, `Copy-Item`, `Rename-Item`, `Remove-Item`.

## Evaluación

Rúbrica incluida al final del documento (100 puntos totales, repartidos entre las 4 partes del comando).
