extends Node2D

@export var player: Player
@export var death_meter: TextureProgressBar

var death_value: float = 0.0

var burning: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if burning:
		MainCam.shake(5, 10, 10)
		death_value += 120.0 * delta
	else:
		var player_speed_ratio = player.linear_velocity.length() / 100.0
		death_value -= player_speed_ratio * delta
	
	death_value = clamp(death_value, 0.0, 100.0)
	death_meter.value = death_value


func _on_player_burnt() -> void:
	burning = true


func _on_player_unburnt() -> void:
	burning = false


func _on_wave_handler_enemy_killed(enemy: Node2D) -> void:
	death_value -= 5.0
