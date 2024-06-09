extends PlayerState

@export var smasher: CollisionShape2D
@export var light_detect: CollisionShape2D
@export var grapple_speed: float = 500.0

@export var grapple_line: Line2D
@export var launch_window: Timer
@export var launch_particles: GPUParticles2D
@export var launch_celebrate: GPUParticles2D

var previous_vel: Vector2
var grapple_point: Area2D

var in_grapple: bool = false

func enter(msg:={}) -> void:
	if msg.has("grapple"):
		grapple_point = msg["grapple"]
		previous_vel = player.linear_velocity
		player.linear_velocity = Vector2.ZERO
		player.gravity_scale = 0
		player.latch_sound.play()
		player.hook_sound.play()
		MainCam.shake(2)
		smasher.set_deferred("disabled", false)
		player.grappled.emit(grapple_point)
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
		smasher.set_deferred("disabled", true)
		launch_window.start()
	
	if in_grapple:
		smasher.set_deferred("disabled", false)
		light_detect.set_deferred("disabled", true)
		player.apply_central_impulse(
			player.linear_velocity
			+ ( player.linear_velocity.normalized() * previous_vel.length() * 0.25 )
		)
		launch_particles.restart()
		launch_celebrate.restart()
		player.launch_sound.play()
		state_machine.transition_to("Fall")

func exit() -> void:
	grapple_line.clear_points()
	player.gravity_scale = 0.5
	player.hook_sound.stop()
	in_grapple = false


func _on_launch_detect_area_entered(area: Area2D) -> void:
	if is_active:
		if area == grapple_point:
			if not launch_window.is_stopped():
				in_grapple = true


func _on_launch_detect_area_exited(area: Area2D) -> void:
	if is_active:
		if area == grapple_point:
			in_grapple = false
			state_machine.transition_to("Fall")


func _on_launch_window_timeout() -> void:
	if is_active:
		smasher.set_deferred("disabled", true)
		state_machine.transition_to("Fall")


func _on_launch_particles_finished() -> void:
	smasher.set_deferred("disabled", true)
	light_detect.set_deferred("disabled", false)


func _on_smasher_area_entered(area: Area2D) -> void:
	if is_active:
		if area.owner == grapple_point.owner:
			if not in_grapple:
				smasher.set_deferred("disabled", true)
			state_machine.transition_to("Fall")


func _on_player_died() -> void:
	smasher.set_deferred("disabled", true)
	light_detect.set_deferred("disabled", true)
	state_machine.transition_to("Fall")
