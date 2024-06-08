class_name LightBeam
extends Area2D

signal fired()
signal finished()

@export var length: float = 363.0
@export var charge_time: float = 1.0
@export var sustain_time: float = 1.0

@export var start_width: float = 4.0
@export var end_width: float = 64.0

@export var beam: Line2D
@export var beam_preview: Line2D
@export var collision_shape: CollisionPolygon2D
@export var charge_timer: Timer
@export var sustain_timer: Timer

var tween: Tween

func _ready() -> void:
	beam.clear_points()
	beam.add_point(Vector2.ZERO)
	beam.add_point(Vector2.RIGHT * length)
	beam.width = 0
	beam_preview.points = beam.points
	beam_preview.width = end_width
	expand_beam()
	add_collision()
	charge_timer.start(charge_time)

func expand_beam() -> void:
	var curve = Curve.new()
	var start_fraction := start_width / end_width
	curve.add_point( Vector2(0.0, start_fraction), 1, 1, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )
	curve.add_point( Vector2(1.0, 1.0), 1, 1, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )
	beam.width_curve = curve
	beam_preview.width_curve = curve

func add_collision() -> void:
	var collision_points := PackedVector2Array()
	
	collision_points.append( Vector2(0, (-start_width / 2.0) - 4.0) )
	collision_points.append( Vector2(length, -end_width / 2.0) )
	
	collision_points.append( Vector2(length, end_width / 2.0) )
	collision_points.append( Vector2(0, (start_width / 2.0) + 4.0) )
	
	collision_shape.polygon = collision_points


func _on_charge_timer_timeout() -> void:
	fired.emit()
	if tween != null:
		tween.stop()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		beam, "width",
		end_width, 0.5
	)
	tween.tween_property(
		beam, "default_color",
		Color.WHITE, 0.5
	).from(Color.BLACK)
	tween.play()
	await tween.finished
	collision_shape.set_deferred("disabled", false)
	sustain_timer.start(sustain_time)

func kill() -> void:
	collision_shape.set_deferred("disabled", true)
	if tween != null:
		tween.stop()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		beam, "width",
		0.0, 0.5
	)
	tween.tween_property(
		beam_preview, "width",
		0.0, 0.5
	)
	tween.tween_property(
		beam, "default_color",
		Color.BLACK, 0.5
	)
	tween.play()
	await tween.finished
	queue_free()

func _on_sustain_timer_timeout() -> void:
	finished.emit()
	kill()
