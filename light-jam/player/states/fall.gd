extends PlayerState

@export var hook_detect: PlayerHookDetect
@export var move_speed: float = 500.0

func physics_update(delta: float) -> void:
	player.apply_central_force(
		Vector2.RIGHT * player.get_move_axis() * move_speed
	)
	
	if Input.is_action_just_pressed("left_click"):
		if hook_detect.targeted_grapple != null:
			state_machine.transition_to("Hook", {"grapple": hook_detect.targeted_grapple})
	
	#if player.global_position.y > 256 + 16:
		#player.apply_central_impulse(Vector2.UP * 500.0)
