class_name Player
extends RigidBody2D

@export var shape: Polygon2D
@export var fill: Polygon2D
@export var burn_particles: GPUParticles2D

@export var hook_sound: AudioStreamPlayer
@export var latch_sound: AudioStreamPlayer
@export var launch_sound: AudioStreamPlayer
@export var buzz_sound: AudioStreamPlayer

var lights: Array[LightBeam]

func _ready() -> void:
	MainCam.target = self
	draw_shape()

func _process(delta: float) -> void:
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
	lights.append(area)
	burn_particles.emitting = true
	if not buzz_sound.playing:
		buzz_sound.play()


func _on_light_detect_area_exited(area: Area2D) -> void:
	lights.erase(area)
	if lights.size() <= 0:
		burn_particles.emitting = false
		buzz_sound.stop()