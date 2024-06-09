class_name RapidoState
extends State

var enemy: Rapido

func _ready() -> void:
	await owner.ready
	enemy = owner as Rapido
	assert(enemy != null)
