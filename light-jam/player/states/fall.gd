extends PlayerState

@export var move_speed: float = 250.0

func physics_update(delta: float) -> void:
	player.apply_central_force(
		Vector2.RIGHT * player.get_move_axis() * move_speed
	)
	
	if player.global_position.y > 256 + 16:
		player.apply_central_impulse(Vector2.UP * 500.0)
