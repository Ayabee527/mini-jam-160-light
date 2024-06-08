class_name PlayerHookDetect
extends Area2D

@export var player: Player
@export var grapple_highlight: Polygon2D

var grapple_points: Array[Area2D]

var sine: float = 0.0

var targeted_grapple: Area2D

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	grapple_highlight.global_rotation_degrees += 180.0 * delta
	
	if targeted_grapple != null:
		grapple_highlight.global_position = targeted_grapple.global_position
	grapple_highlight.scale = Vector2.ONE * ((0.25 * sin(sine)) + 1.0)
	
	sine += 5.0 * delta
	sine = fposmod(sine, TAU * 5.0)

func update_highlight() -> void:
	var closest: Area2D = null
	var closest_dist: float = INF
	for grapple: Area2D in grapple_points:
		var dist = player.global_position.distance_to(grapple.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = grapple
	
	targeted_grapple = closest

func _on_area_entered(area: Area2D) -> void:
	if not grapple_points.has(area):
		grapple_points.append(area)
		update_highlight()
		grapple_highlight.show()


func _on_area_exited(area: Area2D) -> void:
	if grapple_points.has(area):
		grapple_points.erase(area)
	
	if grapple_points.size() > 0:
		update_highlight()
	else:
		targeted_grapple = null
		grapple_highlight.hide()
