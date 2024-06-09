class_name SpotlightEnemy
extends RigidBody2D

signal smashed()

@export var smash_detect: CollisionShape2D
@export var grapple: CollisionShape2D
@export var anim_player: AnimationPlayer

@export var die_sound: AudioStreamPlayer

var dead: bool = false

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_smash_detect_area_entered(area: Area2D) -> void:
	if not dead:
		smash_detect.set_deferred("disabled", true)
		grapple.set_deferred("disabled", true)
		smashed.emit()
		dead = true
		MainCam.shake(15, 10, 10)
		MainCam.hitstop(0.2, 0.5)
		die_sound.play()
