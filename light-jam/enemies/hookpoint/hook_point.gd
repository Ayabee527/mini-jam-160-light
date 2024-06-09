class_name HookPoint
extends RigidBody2D

signal smashed()

@export var smash_detect: CollisionShape2D
@export var grapple: CollisionShape2D
@export var anim_player: AnimationPlayer

var spawn_point: Vector2

func _ready() -> void:
	spawn_point = global_position
	global_position += Vector2.from_angle(TAU * randf()) * randf_range(0.0, 32.0)


func _on_smash_detect_area_entered(area: Area2D) -> void:
	return
	smash_detect.set_deferred("disabled", true)
	grapple.set_deferred("disabled", true)
	smashed.emit()
	MainCam.shake(5, 5, 5)
	MainCam.hitstop(0.2, 0.25)
