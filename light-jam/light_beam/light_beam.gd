class_name LightBeam
extends Area2D

@export var length: float = 363.0
@export var start_width: float = 4.0
@export var end_width: float = 64.0

@export var beam: Line2D
@export var collision_shape: CollisionPolygon2D

func _ready() -> void:
	beam.clear_points()
	beam.add_point(Vector2.ZERO)
	beam.add_point(Vector2.RIGHT * length)
	beam.width = end_width
	expand_beam()
	add_collision()

func expand_beam() -> void:
	var curve = Curve.new()
	var start_fraction := start_width / end_width
	curve.add_point( Vector2(0.0, start_fraction), 1, 1, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )
	curve.add_point( Vector2(1.0, 1.0), 1, 1, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )

func add_collision() -> void:
	var collision_points := PackedVector2Array()
	
	collision_points.append( Vector2(0, (-start_width / 2.0) - 4.0) )
	collision_points.append( Vector2(length, -end_width / 2.0) )
	
	collision_points.append( Vector2(length, end_width / 2.0) )
	collision_points.append( Vector2(0, (start_width / 2.0) + 4.0) )
	
	collision_shape.polygon = collision_points
