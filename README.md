# Lotería Push

Lotería multijugador en **Flutter** donde un **cantor en la nube** (servidor Node) canta las cartas por **notificación push** con Firebase Cloud Messaging (FCM). El juego es el pretexto para aprender notificaciones push bien hechas: permiso en contexto, mensajes de datos, segundo plano, colapso de avisos, higiene de tokens, seguridad y pruebas con **TDD**.

José Alejandro Olvera Lugo
GTID244

---

# Evidencia de TDD

Cada ronda sigue el ciclo **ROJO → VERDE**:

# Parte A. Servidor (Node)

## Ronda 2 · La baraja y las líneas ganadoras (`baraja.test.js`, `lineas.test.js`)

54 cartas únicas, el mazo barajado con semilla, la tabla de 16 cartas, los 12 patrones ganadores y el cálculo de "a qué carta le falta".

**Rojo**

![Ronda 2 - rojo](capturas/ronda2_rojo.png)

**Verde** (22 pruebas: 6 + 16)

![Ronda 2 - verde](capturas/ronda2_verde.png)

## Ronda 3 · Armar mensajes push correctos (`mensajes.test.js`)

Mensaje de carta al tema de la sala, `data` con todos los valores como cadenas, caducidad de 60 s, colapso en Android e iOS, canales por tipo de aviso y límite de 4 KB.

**Rojo**

![Ronda 3 - rojo](capturas/ronda3_rojo.png)

**Verde** (9 pruebas)

![Ronda 3 - verde](capturas/ronda3_verde.png)

## Ronda 4 · La sala: reglas, autorización y trampas (`sala.test.js`)

Unirse con nombres válidos, cantar en el orden del mazo secreto, freno de cantos muy rápidos, reclamar la lotería (el servidor valida), el aviso de "¡casi!" una sola vez por jugador y autorización por clave.

**Rojo**

![Ronda 4 - rojo](capturas/ronda4_rojo.png)

**Verde** (18 pruebas)

![Ronda 4 - verde](capturas/ronda4_verde.png)

## Ronda 5 · El servidor HTTP y el envío seguro (`servidor.test.js`)

Flujo completo (crear sala, unirse, cantar, ver el push), clave del cantor, freno 429, estado por `desde`, fallos de FCM sin romper el estado, token muerto eliminado, destino por token o por FID, entradas malas y errores internos sin filtrar detalles.

**Rojo**

![Ronda 5 - rojo](capturas/ronda5_rojo.png)

**Verde** (12 pruebas)

![Ronda 5 - verde](capturas/ronda5_verde.png)

## Todas las pruebas del servidor

![Servidor - todas verdes](capturas/servidor_todas_verde.png)

# Parte B. App (Flutter)

## Ronda 6 · Parsear eventos y mantener la partida (`evento_lineas_test.dart`, `partida_test.dart`)

Parsear lo que llega con desconfianza y mantener la partida de forma idempotente y consciente de huecos.

**Rojo**

![Ronda 6 - rojo](capturas/ronda6_rojo.png)

**Verde** (27 pruebas)

![Ronda 6 - verde](capturas/ronda6_verde.png)

## Ronda 7 · Puertos, doble de pruebas y controlador (`controlador_test.dart`)

La app habla con el mundo por dos puertas (push y API) y se prueba con dobles de prueba (`falsos.dart`) sin Firebase ni red.

**Rojo**

![Ronda 7 - rojo](capturas/ronda7_rojo.png)

**Verde** (22 pruebas)

![Ronda 7 - verde](capturas/ronda7_verde.png)


## Ronda 9 · Pantallas, ViewModels y arranque (`pantalla_test.dart`)

La pantalla muestra la sala y el aviso de "sin push", el botón **¡LOTERÍA!** está apagado hasta completar un patrón y, cuando otro jugador gana, aparece el mensaje y el botón se apaga.

**Rojo**

![Ronda 9 - rojo](capturas/ronda9_rojo.png)

**Verde** (3 pruebas)

![Ronda 9 - verde](capturas/ronda9_verde.png)

## Todas las pruebas de la app

![App - todas verdes](capturas/app_todas_verde.png)

# La app funcionando en el teléfono

Probada en un dispositivo Android real, con el servidor corriendo en la computadora y push real a través de Firebase.

### 1. Pantalla inicial

Sin ningún diálogo de permiso al abrir. Se puede unir a una sala o crear una como cantor.

<img src="capturas/img01.jpeg" alt="Pantalla inicial" width="260">

### 2. Pantalla del cantor

El código de la sala para compartir, el botón para cantar la siguiente carta y el interruptor para cantar automáticamente cada 6 segundos.

<img src="capturas/img02.jpeg" alt="Pantalla del cantor" width="260">

### 3. Permiso en contexto

Antes del diálogo del sistema, la app explica para qué sirven los avisos (cuando se canta una carta y cuando estás a UNA de ganar) y deja elegir "Mejor no".

<img src="capturas/img03.jpeg" alt="Pregunta previa al permiso" width="260">

### 4. La sala

La tabla de 16 cartas, "Esperando la primera carta..." y el botón **¡LOTERÍA!** apagado.

<img src="capturas/img04.jpeg" alt="Sala en espera" width="260">

### 5. Carta cantada

Llegó la carta **#2 · El Elote**: se muestra arriba con su pista y, como está en la tabla, la casilla queda marcada con un frijol.

<img src="capturas/img05.jpeg" alt="Carta cantada" width="260">

### 6 y 7. Notificaciones push de las cartas

Las cartas llegan como notificación push a la bandeja del sistema (aquí "El Cotorro" y "El Árbol", con su pista).

<img src="capturas/img06.jpeg" alt="Push: El Cotorro" width="260"> <img src="capturas/img07.jpeg" alt="Push: El Árbol" width="260">

---
