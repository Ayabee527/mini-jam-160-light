class_name SpotlightState
extends State

var enemy: SpotlightEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as SpotlightEnemy
	assert(enemy != null)
