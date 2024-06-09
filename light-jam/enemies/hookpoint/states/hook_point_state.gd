class_name HookPointState
extends State

var hook_point: HookPoint

func _ready() -> void:
	await owner.ready
	hook_point = owner as HookPoint
	assert(hook_point != null)
