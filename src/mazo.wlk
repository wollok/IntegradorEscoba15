class Carta {

	const numero
	const palo

	method valor() = if (numero <= 7) numero else numero - 2

	method esDeOro() = palo == 'oros'

	method es7DeOro() = self.valor() == 7 && self.esDeOro()

}

object mesa {

	const property cartas = []
	const property jugadores = []

	method valorCartas() = cartas.sum{ c => c.valor() }

	method agregarCarta(carta) {
		cartas.add(carta)
	}

	method despejar() {
		cartas.clear()
	}

	method haceEscoba(carta) = carta.valor() == 15 - self.valorCartas()

	method esJugadorConMasCartas(jugador) = jugadores.all{ j => jugador.cantidadCartas() >= j.cantidadCartas() }

}

class Jugador {

	const cartas = []
	const monton = []
	var escobas = 0
	var property actitud = distraido

	method puedeHacerEscoba() = cartas.any{ c => mesa.haceEscoba(c) }

	method jugada() {
		if (self.puedeHacerEscoba()) 
			self.hacerEscoba() 
		else 
			self.tirarCarta(actitud.queCartaTirar(self))
	}

	method hacerEscoba() {
		self.juntarCartaPropia(self.cartaParaHacerEscoba())
		self.juntarCartasMesa()
		self.contabilizarEscoba()
	}

	method juntarCartasMesa() {
		monton.addAll(mesa.cartas())
		mesa.despejar()
	}

	method juntarCartaPropia(carta) {
		monton.add(carta)
		cartas.remove(carta)
	}

	method contabilizarEscoba() {
		escobas += 1
	}

	method tirarCarta(carta) {
		cartas.remove(carta)
		mesa.agregarCarta(carta)
	}

	method cartaParaHacerEscoba() = cartas.find{ c => mesa.haceEscoba(c) }

	method puntaje() = escobas + self.puntos7DeOro() + self.puntosMasCartas()

	method tiene7DeOro() = monton.any{ c => c.es7DeOro() }

	method puntos7DeOro() = if (self.tiene7DeOro()) 1 else 0

	method puntosMasCartas() = if (mesa.esJugadorConMasCartas(self)) 1 else 0

	method cantidadCartas() = monton.size()

	method primeraCarta() = cartas.first()
	
	method cartaMasAlta() = cartas.max{ c => c.valor() }

	method cartaNoValiosaMasAlta() = if (self.soloTiene7DeOro()) self.primeraCarta() else self.cartaMasAltaSin7DeOro()   
	
	method cartaMasAltaSin7DeOro() = cartas.filter{ c => not c.es7DeOro() }.max{ c => c.valor() }
	
	method soloTiene7DeOro() = cartas.size() == 1 && cartas.first().es7DeOro() 
}

object distraido {

	method queCartaTirar(jugador) = jugador.primeraCarta()

}

object atento {

	method queCartaTirar(jugador) = jugador.cartaMasAlta()

}

object precavido {

	method queCartaTirar(jugador) = jugador.cartaNoValiosaMasAlta()

}

//Variantes
// 1) Para el público de otras latitudes, se quiere incluir la posibilidad de jugar con cartas francesas 
// (los palos son diamante, corazón, pica y trébol, y los valores son la A, números del 2 al 10, la J, Q y K) 
// Realizar las modificaciones necesarias para permitir jugar tanto con cartas españolas como franceses 
// e incluso mezclando los mazos. 
// (por ejemplo, se puede tomar a diamante como oros y buscarle un valor acorde a las cartas con letras)

class CartaFrancesa inherits Carta {

	override method valor() {
		if (numero == 'A') return 1
		if (numero == 'J') return 11
		if (numero == 'Q') return 12
		if (numero == 'K') return 13
		return numero
	}

	override method esDeOro() = palo == "diamante"

}


// Agregar una nueva tarea que es generar un mazo: 
// se desea poder armar un mazo (puede ser de cartas españolas o francesas) 
// de manera que sabiendo cuáles son los palos y los números, se creen todas las cartas correspondientes. 

class Mazo {

	var palos = []
	var numeros = []
	const property cartas = []

 	method inicializar()

	method generar() {
		self.inicializar()
		numeros.forEach{ numero => palos.forEach{ palo => cartas.add(self.nuevaCarta(numero, palo))}}
	}

	method nuevaCarta(numero, palo)
	

}

class MazoEspanol inherits Mazo{

 	override method inicializar(){
 		palos = ['oros','copa','espada','basto']
 		numeros = [1,2,3,4,5,6,7,10,11,12]
 	}

	override method nuevaCarta(numero, palo) = new Carta(numero = numero, palo = palo)

}

class MazoFrances inherits Mazo {

	override method inicializar() {
		palos = ['diamante', 'corazon', 'trebol', 'pica']
		numeros = [ 'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
	}

	override method nuevaCarta(numero, palo) = new CartaFrancesa(numero = numero, palo = palo)

}



// Otra opción, más genérica

class MazoConEstilo {
	const estilo 
	const property cartas = []

	method generar() {
		estilo.numeros().forEach{ numero => 
			estilo.palos().forEach{ palo => 
				cartas.add(estilo.nuevaCarta(numero, palo))
			}
		}
	}
}

object espanol{
	method palos() = [ 'oros', 'copa', 'espada', 'basto' ]
	method numeros() = [ 1, 2, 3, 4, 5, 6, 7, 10, 11, 12 ]
	method nuevaCarta(numero,palo) = new Carta(numero = numero, palo = palo)
}

object frances{
	method palos() = ['diamante', 'corazon', 'trebol', 'pica']
	method numeros() = [ 'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
	method nuevaCarta(numero,palo) = new CartaFrancesa(numero = numero, palo = palo)
}


// Se quiere poder generar mazos que contengan también una cierta cantidad de comodines. 
// Los comodines son cartas especiales que no tienen literalmente un número o un palo, 
// pero asumen los valores propios de la carta a la que el jugador desea que reemplacen. 
// Incluirlos de manera que se pueda jugar a la escoba de 15 con comodines, 
// considerando que si el jugador ya estableció el comodín a qué carta sustituye, 
// se usa y contabiliza como dicha carta 
// (no está contemplado qué debe suceder en el juego si no se sabe a qué carta refiere el comodín, 
// por lo que se debe advertir apropiadamente de dicha situación) 

class ComodinException inherits Exception { }

class Comodin {

	var property carta = null

	method palo() {
		self.validarSinCarta()
		return carta.palo()
	}

	method valor() {
		self.validarSinCarta()
		return carta.valor()
	}

	method validarSinCarta() {
		if (carta == null) throw new ComodinException()
	}

	method es7DeOro() {
		self.validarSinCarta()
		return carta.es7DeOro()
	}

}

class MazoConComodines inherits MazoConEstilo {

	const cantidadComodines

	override method generar() {
		super()
		cantidadComodines.times{ i => cartas.add(new Comodin())}
	}

}

