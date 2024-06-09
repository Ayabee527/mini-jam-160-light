extends HookPointState

@export var bap_timer: Timer

func enter(_msg:={}) -> void:
	bap_timer.start()

func physics_update(delta: float) -> void:
	var move_speed: float = randf_range(100.0, 500.0)
	var dir_to_spawn = hook_point.global_position.direction_to(hook_point.spawn_point)
	hook_point.apply_central_force(
		dir_to_spawn * move_speed
	)

func exit() -> void:
	bap_timer.stop()

func _on_smash_detect_area_entered(area: Area2D) -> void:
	return
	if is_active:
		state_machine.transition_to("Frozen", {"died": true})


func _on_bap_timer_timeout() -> void:
	hook_point.apply_central_impulse(
		Vector2.from_angle(TAU * randf()) * 75.0
	)
