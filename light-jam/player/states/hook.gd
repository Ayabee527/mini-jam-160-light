extends PlayerState

@export var grapple_speed: float = 500.0

@export var grapple_line: Line2D
@export var launch_window: Timer
@export var launch_particles: GPUParticles2D

var grapple_point: Area2D

func enter(msg:={}) -> void:
	if msg.has("grapple"):
		grapple_point = msg["grapple"]
		player.linear_velocity = Vector2.ZERO
		player.gravity_scale = 0
		player.latch_sound.play()
		player.hook_sound.play()
	else:
		state_machine.transition_to("Fall")

func physics_update(delta: float) -> void:
	var dir_to_grapple_point = player.global_position.direction_to(grapple_point.global_position)
	
	player.apply_central_force(
		dir_to_grapple_point * grapple_speed
	)
	
	grapple_line.global_position = Vector2.ZERO
	grapple_line.global_rotation = 0
	grapple_line.clear_points()
	grapple_line.add_point(player.global_position)
	grapple_line.add_point(grapple_point.global_position)
	
	if Input.is_action_just_released("left_click"):
		state_machine.transition_to("Fall")

func exit() -> void:
	grapple_line.clear_points()
	player.gravity_scale = 0.5
	player.hook_sound.stop()
	if not launch_window.is_stopped():
		player.apply_central_impulse(Vector2.UP * player.linear_velocity.length())
		launch_particles.restart()
		player.launch_sound.play()


func _on_launch_detect_area_entered(area: Area2D) -> void:
	if area == grapple_point:
		launch_window.start()


func _on_launch_detect_area_exited(area: Area2D) -> void:
	if area == grapple_point:
		launch_window.stop()
		state_machine.transition_to("Fall")


func _on_launch_window_timeout() -> void:
	state_machine.transition_to("Fall")
