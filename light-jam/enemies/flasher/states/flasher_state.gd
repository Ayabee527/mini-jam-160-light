class_name FlasherState
extends State

var enemy: Flasher

func _ready() -> void:
	await owner.ready
	enemy = owner as Flasher
	assert(enemy != null)
