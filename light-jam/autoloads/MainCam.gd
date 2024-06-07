extends Camera2D

var target: Node2D

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position
