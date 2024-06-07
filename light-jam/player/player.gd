class_name Player
extends RigidBody2D

@export var shape: Polygon2D
@export var fill: Polygon2D

func _ready() -> void:
	MainCam.target = self
	draw_shape()

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
