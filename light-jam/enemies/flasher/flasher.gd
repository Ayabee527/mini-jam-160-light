class_name Flasher
extends RigidBody2D

signal smashed()

@export var smash_detect: CollisionShape2D
@export var grapple: CollisionShape2D
@export var anim_player: AnimationPlayer

@export var state_machine: StateMachine

var player: Player
var dead: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_smash_detect_area_entered(area: Area2D) -> void:
	if not dead:
		smash_detect.set_deferred("disabled", true)
		grapple.set_deferred("disabled", true)
		smashed.emit()
		dead = true
		MainCam.shake(1, 30, 2)
		MainCam.hitstop(0.25, 0.5)
