class_name SniperState
extends State

var enemy: Sniper

func _ready() -> void:
	await owner.ready
	enemy = owner as Sniper
	assert(enemy != null)
