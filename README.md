# Escoba de 15

**Ejercicio integrador**


Uno de los juegos clásicos de cartas es el denominado "escoba de 15". Es un juego de origen hispánico, muy difundido en Argentina y otros países de la región, que se juega con un mazo de cartas españolas.
Como suele suceder en este tipo de juegos existen variantes en algunas reglas y es difícil establecer cuál es el reglamento "oficial" ([pueden ver uno acá](https://www.wikiwand.com/es/Escoba_del_15)). Por lo tanto, vamos a definir nuestras propias reglas de juego, lo que nos permite simplificar algunos aspectos, limitarnos a implementar algunas de las funcionalidades e introducir variantes que resulten interesantes. 

## Desarrollo del juego

Se puede jugar de 2 o más jugadores. Al comienzo del juego cada uno recibe tres cartas y se colocan cuatro cartas boca arriba en la mesa. Cada jugador en su turno elige entre sus cartas cuál es la que quiere jugar. La clave del juego es combinar una de las cartas que tiene el jugador en su mano con las que hay en la mesa de manera de sumar 15, y de esta manera poder "levantarlas" y llevárselas a su propio montón. En caso que lo logre utilizando todas las cartas que hay en la mesa y por lo tanto quede vacía, se la llama "escoba" y vale un punto para el jugador que la realiza. En caso que lo haga con sólo algunas de las cartas de la mesa, se lleva de todas maneras las que levantó y las restantes quedan en la mesa. Lo que es frecuente es que el jugador no tenga forma de combinar 15, por lo que simplemente tira una carta a la mesa y no levanta nada. 
Cuando todos los jugadores jugaron sus cartas se vuelve a repartir, tantas veces como sean posibles hasta agotar el mazo. Al terminar se analizan las cartas recogidas por cada jugador en su montón y en función de ellos se calculan los puntos que obtuvo cada uno.

**Mazo de cartas españolas**
- Son 40 cartas.
- Los palos son: basto, copa, espada, y oro. 
- Los números van del 1 al 7 y del 10 al 12, pero el valor es el siguiente:
- Números del 1 al 7: lo mismo que indica su número
- Figuras: sota (10), caballo (11) y rey (12): 8, 9 y 10 respectivamente, es decir, dos menos que su número. 

## Requerimientos

### Planteo inicial:

1. Permitir representar la situación de un jugador en un momento determinado del juego. 

Por ejemplo:
- Lola tiene tres cartas (4 de copa, 1 de basto y caballo de oros), su montón está aún vacío. 
- Cachito tiene dos cartas (3 de oros y 5 de copa), en su montón tiene dos cartas que levantó en la jugada anterior (7 de oros y sota de copa) 
- En la mesa hay algunas cartas (rey de basto, 1 de espada, 1 de oro)._

2. Evaluar si un jugador puede hacer escoba. 
En el ejemplo anterior, Lola no puede hacer escoba (si juega el 4 suma 16 y se pasa, con el caballo más aún, y si juega el 1 suma 13 y le falta), en cambio cachito sí (con el 3 suma justo 15)
Calcular cuántos puntos obtuvo un jugador en la partida, teniendo en cuenta que el puntaje se distribuye de la siguiente manera:
- Un punto por cada escoba realizada
- Un punto al jugador que haya juntado más cartas en su montón (si hay empate, se le da un punto a todos los jugadores que hayan empatado)
- Un punto al jugador que tenga el 7 de oros en su montón.

### Jugador inteligente

Lo más interesante es modelar la estrategia de juego
Implementar la jugada que hace un jugador cuando le llega su turno, teniendo en cuenta:
  - Si puede hacer escoba, la hace.
  - Si no, directamente tira una carta a la mesa. (en esta implementación vamos a omitir que pueda levantar otras cartas)

Lo que sí, no va a tirar cualquier carta, sino que va a depender de lo siguiente:
  - Si el jugador está distraído tira la primera que tiene
  - Un jugador atento tira la carta de mayor valor (para minimizar la posibilidad de hacer escoba de los otros jugadores)
  - Los jugadores precavidos también tiran las de mayor valor, pero evitan tirar un 7 de oros salvo que sea la única carta que le queda.  

Permitir que en cualquier momento de la partida un jugador cambie su actitud en el juego. Por ejemplo, un jugador que  estaba distraído se pone a prestar atención o uno que estaba precavido se distrae. 

Inventar un nueva forma de estar en el juego que implique otro criterio de elegir la carta a tirar, e implementarlo de manera que no requiera modificar lo hecho anteriormente, sino sólo agregar nuevos elementos. Justificar conceptualmente.

### Variantes

Intentando sumar nuevos adeptos, surgen algunas variantes en el juego.

1. Para el público de otras latitudes, se quiere incluir la posibilidad de jugar con cartas francesas (los palos son diamante, corazón, pica y trébol, y los valores son la A, números del 2 al 10, la J, Q y K) Realizar las modificaciones necesarias para permitir jugar tanto con cartas españolas como franceses e incluso mezclando los mazos. (por ejemplo, se puede tomar a diamante como oros y buscarle un valor acorde a las cartas con letras)

2. Agregar una nueva tarea que es generar un mazo: se desea poder armar un mazo (puede ser de cartas españolas o francesas) de manera que sabiendo cuáles son los palos y los números, se creen todas las cartas correspondientes. 
3. Se quiere poder generar mazos que contengan también una cierta cantidad de comodines. Los comodines son cartas especiales que no tienen literalmente un número o un palo, pero asumen los valores propios de la carta a la que el jugador desea que reemplacen. Incluirlos de manera que se pueda jugar a la escoba de 15 con comodines, considerando que si el jugador ya estableció el comodín a qué carta sustituye, se usa y contabiliza como dicha carta (no está contemplado qué debe suceder en el juego si no se sabe a qué carta refiere el comodín, por lo que se debe advertir apropiadamente de dicha situación) 
4. ¿Qué nuevos cambios implicaría agregar otros tipos de mazo o cartas? Justificar conceptualmente. En particular, plantear una situación hipotética en la cual la herencia sea de utilidad? 


### Pruebas
Hacer tests de los principales items

[Consigna](https://docs.google.com/document/d/1FnnmSwEuaWQN_L8nA4MWfyL30quYUmusHO9z5p_Onco/)
