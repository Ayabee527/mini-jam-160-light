class_name Player
extends RigidBody2D

signal burnt()
signal unburnt()

signal grappled(target: Node2D)

signal died()

@export var shape: Polygon2D
@export var fill: Polygon2D
@export var burn_particles: GPUParticles2D
@export var death_particles: GPUParticles2D
@export var trail_particles: GPUParticles2D

@export var hook_sound: AudioStreamPlayer
@export var latch_sound: AudioStreamPlayer
@export var launch_sound: AudioStreamPlayer
@export var buzz_sound: AudioStreamPlayer
@export var bounce_sound: AudioStreamPlayer

var lights: Array[LightBeam]

var dead: bool = false

func _ready() -> void:
	MainCam.target = self
	draw_shape()

func _process(delta: float) -> void:
	if not dead:
		if lights.size() > 0:
			burn_particles.look_at(lights.back().global_position)

func draw_shape() -> void:
	var radius: float = 6.0
	var fill_radius: float = 3.5
	
	var detail := 16
	var shape_points := PackedVector2Array()
	var fill_points := PackedVector2Array()
	for i: int in range(detail):
		var ang = TAU * (float(i) / detail)
		var shape_point = Vector2.from_angle(ang) * radius
		var fill_point = Vector2.from_angle(ang) * fill_radius
		shape_points.append(shape_point)
		fill_points.append(fill_point)
	
	shape.polygon = shape_points
	fill.polygon = fill_points

func get_move_axis() -> float:
	return Input.get_axis(
		"move_left", "move_right"
	)

func _on_light_detect_area_entered(area: Area2D) -> void:
	if not dead:
		lights.append(area)
		burn_particles.emitting = true
		if not buzz_sound.playing:
			buzz_sound.play()
			burnt.emit()


func _on_light_detect_area_exited(area: Area2D) -> void:
	if not dead:
		lights.erase(area)
		if lights.size() <= 0:
			burn_particles.emitting = false
			buzz_sound.stop()
			unburnt.emit()


func _on_body_entered(body: Node) -> void:
	MainCam.shake(3, 5, 15)
	bounce_sound.play()

func die() -> void:
	if not dead:
		dead = true
		shape.hide()
		trail_particles.hide()
		death_particles.restart()
		set_deferred("freeze", true)
		died.emit()
		
		burn_particles.emitting = false
		buzz_sound.stop()
		unburnt.emit()

func _on_smasher_area_entered(area: Area2D) -> void:
	pass
	#apply_central_impulse(linear_velocity.normalized() * 250.0)
