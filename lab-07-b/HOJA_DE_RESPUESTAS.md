# Hoja de respuestas · Práctica «Un archivo, tres mundos»

**UAEMEX · Licenciatura en Informática Administrativa · Sistemas Operativos · 3.er semestre**

---

## Instrucciones de entrega (léelas antes de empezar)

1. Responde **a mano** en esta hoja impresa o en una hoja tamaño carta (blanca o cuadriculada) con las preguntas numeradas del 1 al 12.
2. Llena el encabezado **completo**. El identificador del equipo y la huella SHA-256 los copias de tu bitácora (registros `S1.2` y `S7.4`): así tu hoja queda ligada a tu evidencia digital.
3. Responde cada pregunta **al terminar la sección que le corresponde**, no al final. Usa tus propias palabras, de 2 a 4 renglones. Cuando se pida un dato (un número, una ruta, un comando), cópialo exactamente de tu pantalla o de tu bitácora.
4. Al terminar la clase, **firma y entrega la hoja física al profesor antes de salir del salón**. No se aceptan fotografías ni archivos digitales de esta hoja.
5. Además, envía por correo tu `bitacora_<cuenta>.log` y tu `entrega_<cuenta>.zip` como indica la Sección 7 de tu guía.

---

## Encabezado

| Campo | Respuesta |
|---|---|
| Nombre completo | |
| Número de cuenta | |
| Grupo | |
| Fecha | |
| Sistema operativo del equipo (Windows 10 / 11, macOS, Linux) | |
| Identificador del equipo (registro `S1.2` de tu bitácora) | |
| Huella SHA-256 del `.zip`, primeros 8 caracteres (registro `S7.4`) | |

---

## Sección 1 · Identidad, carpeta y bitácora

**1.** Explica por qué la guía obtuvo la ruta de tu Escritorio *preguntándole al sistema* en lugar de escribirla a mano. Menciona al menos **dos situaciones** en las que una ruta escrita a mano fallaría en otra computadora.

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**2.** ¿Qué significa que un procedimiento sea **idempotente**? Da **dos ejemplos** de comandos o banderas de la práctica que lo logran y explica por qué esto le importa a un administrador informático.

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 2 · Tres mundos, tres nombres

**3.** Escribe la ruta completa de tu carpeta de proyecto **vista desde tu sistema operativo** y **vista desde el contenedor**. Si es la misma carpeta, ¿por qué tiene dos nombres? Señala **dos diferencias de nomenclatura** entre ambas rutas.

Desde mi sistema: _____________________________________________________________

Desde el contenedor: __________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**4.** Anota lo que reportaron los registros `S2.1`, `S2.2`, `S2.3` y la primera línea de `S2.4`. ¿Qué kernels coinciden y cuál no? ¿Qué te dice esto sobre **dónde se ejecutan realmente** los contenedores en tu equipo?

Cliente / Servidor (S2.1): ____________________________________________________

Anfitrión (S2.2): _____________________ Máquina virtual (S2.3): _______________

Contenedor (S2.4): ____________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**5.** ¿Por qué desapareció `/tmp/prueba.txt` y en cambio sobrevivió `/datos/firma.txt`? ¿Por qué la ruta `/var/lib/docker/volumes` **no existe** en tu computadora, aunque Docker diga que el volumen está ahí?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 3 · Navegación

**6.** ¿Cuál es la diferencia entre una **ruta absoluta** y una **relativa**? Da un ejemplo de cada una que hayas usado. Además, ¿qué información extra te dieron `ls -l`, `ls -la` y `ls -lh`, y en qué situación de trabajo usarías cada una?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 4 · Construir y editar

**7.** Describe la diferencia entre `cp`, `mv` y `rm` según lo que hiciste con `notas.txt`, `borrador.txt` y `basura.tmp`. ¿Por qué `rm` en un servidor Linux es más riesgoso que «Eliminar» en tu explorador de archivos? ¿Qué hiciste **antes** de modificar `notas.txt` que te protege de ese riesgo?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**8.** ¿Cuántos archivos quedaron al crear `Nota.txt` y `nota.txt` en el contenedor (`S4.5`) y cuántos en tu sistema (`S7.1`)? ¿Qué contenido quedó en tu sistema? Describe un **problema real** que esto podría causar al copiar archivos entre un servidor Linux y una computadora Windows o macOS.

Contenedor: ______ archivos   Mi sistema: ______ archivos   Contenido: ______

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 5 · Analizar datos

**9.** ¿Cuántas líneas tiene `inventario.csv` y cuántos equipos registra realmente? ¿Cuántos están en mantenimiento? Escribe el **comando que usaste en el reto** para contar los equipos con Windows y su resultado.

Líneas: ______  Equipos: ______  En mantenimiento: ______

Comando del reto: _____________________________________________  Resultado: ______

_______________________________________________________________________________

**10.** ¿En qué casos conviene usar `less` en lugar de `cat`? Relaciónalo con la revisión de la bitácora de un servidor que mide varios gigabytes.

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 6 · Sistema y red

**11.** Según `S6.1` y `S6.2`, ¿qué tipo de sistema de archivos tiene `/` y cuál tiene `/practica`? ¿Por qué reportan tipos o tamaños distintos si «están en el mismo contenedor»?

`/` : ___________________   `/practica` : ___________________

_______________________________________________________________________________

_______________________________________________________________________________

**12.** ¿Cuántos procesos mostró `top` dentro del contenedor y cuántos ves, aproximadamente, en el Administrador de tareas o en el Monitor de Actividad? ¿A qué se debe la diferencia? ¿Qué resultado obtuviste con `ping` y qué concluirías si no hubiera respuesta?

Procesos en el contenedor: ______   En mi sistema: ______   Ping: ______________

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

Declaro que realicé personalmente esta práctica en el equipo indicado en el encabezado.

Firma del alumno: ______________________________

**Para uso del profesor:** Bitácora ☐  ZIP ☐  Huella coincide ☐  Equipo coincide ☐  Calificación: ______
