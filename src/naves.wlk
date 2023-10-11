class Nave {
	var velocidad = 0
	var direccionSol = 0
	var combustible = 0
	
	method velocidad() = velocidad
	
	method acelerar(cuanto) {
		velocidad = 100000.min(velocidad + cuanto)
	}
	
	method desacelerar(cuanto) {
		velocidad = 0.max(velocidad - cuanto)
	}
	
	method direccionSol() = direccionSol
	
	method irHaciaElSol() {
		direccionSol = 10
	}
	
	method escaparDelSol() {
		direccionSol = -10
	}
	
	method ponerseParaleloAlSol() {
		direccionSol = 0
	}
	
	method acercarseUnPocoAlSol() {
		direccionSol = 10.min(direccionSol + 1)
	}
	
	method alejarseUnPocoDelSol() {
		direccionSol = -10.max(direccionSol - 1)
	}
	
	method cargarCombustible(unaCantidad) {
		combustible += unaCantidad
	}
	
	method descargarCombustible(unaCantidad) {
		combustible = 0.max(combustible - unaCantidad)
	}
	
	method prepararViaje() {
		self.accionAdicionalEnPrepararViaje()
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method accionAdicionalEnPrepararViaje()
	
	method estaTranquila() = combustible >= 4000 and velocidad < 12000
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	
	method relajo() {
		return self.estaTranquila() and self.pocaActividad()
	}
	method pocaActividad()
}

class NavesBaliza inherits Nave {
	var color
	var cambioColorBaliza = false
	
	method color() = color
	
	method cambiarColorDeBaliza(colorNuevo) {
		color = colorNuevo
		cambioColorBaliza = true
	}
	
	override method accionAdicionalEnPrepararViaje() {
		color = "verde"
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() {
		return super() and color != "rojo"
	}
	
	override method escapar() {
		self.irHaciaElSol()
	}
	
	override method avisar() {
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method pocaActividad() {
		return not cambioColorBaliza
	}
}

class NavePasajeros inherits Nave {
	var pasajeros
	var comida
	var bebida
	var comidaDescargada = 0
	
	method pasajeros() = pasajeros
	
	method comida() = comida
	
	method bebida() = bebida
	
	method cargarComida(cuanto) {comida += cuanto}
	method descargarComida(cuanto) {
		comida = 0.max(comida - cuanto)
		comidaDescargada = comida.min(cuanto)
	}
	
	method cargarBebida(cuanto) {bebida += cuanto}
	method descargarBebida(cuanto) {bebida = 0.max(comida - cuanto)}
	
	override method accionAdicionalEnPrepararViaje() {
		self.cargarComida(pasajeros * 4)
		self.cargarBebida(pasajeros * 6)
		self.acercarseUnPocoAlSol()
	}
	
	override method escapar() {
		self.acelerar(velocidad)
	}
	
	override method avisar() {
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
	}
	
	override method pocaActividad() {
		return comidaDescargada < 50
	}
}

class NaveCombate inherits Nave {
	var visible = true
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible() {
		visible = true
	}
	method ponerseInvisble() {
		visible = false
	}
	method estaInvicible() = not visible
	
	
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	method replegarMisiles() {
		misilesDesplegados = false
	}
	method misilesDesplegados() = misilesDesplegados
	
	
	method emitirMensaje(mensaje) {
		mensajes.add(mensaje)
	}
	
	method mensajesemitidos() = mensajes.size()
	
	method primerMensajeEmitido() {
		if (mensajes.isEmpty()) {
			self.error("No hay mensajes")
		}
		return mensajes.first()
	}
	
	method ultimoMensajeEmitido() {
		if (mensajes.isEmpty()) {
			self.error("No hay mensaje")
		}
		return mensajes.get(mensajes.size() - 1)
	}
	
	method esEscueta() = mensajes.all({naveMensaje => naveMensaje.size() <= 30})
	
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method accionAdicionalEnPrepararViaje() {
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en mision")
		self.acelerar(15000)
	}
	
	override method estaTranquila() {
		return super() and not misilesDesplegados
	}
	
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method pocaActividad() {
		return self.esEscueta()
	}
}

class NaveHospital inherits NavePasajeros {
	var property quirofanosPreparados = false
	
	override method estaTranquila() {
		return super() and not quirofanosPreparados
	}
	
	override method recibirAmenaza() {
		super()
		quirofanosPreparados = true
	}
}

class NaveSigilosa inherits NaveCombate {
	
	override method estaTranquila() {
		return super() and visible
	}
	
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisble()
	}
}