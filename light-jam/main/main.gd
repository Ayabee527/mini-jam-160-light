extends Node2D

signal game_ended()

@export var player: Player
@export var death_meter: TextureProgressBar

@export var retry_butt: Button
@export var menu_butt: Button

var death_value: float = 0.0

var burning: bool = false

var game_overed: bool = false

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("restart"):
		#get_tree().reload_current_scene()
	
	if not game_overed:
		if burning:
			MainCam.shake(5, 10, 10)
			death_value += 60.0 * delta
		else:
			var player_speed_ratio = player.linear_velocity.length() / 100.0
			death_value -= player_speed_ratio * delta
	
		death_value = clamp(death_value, 0.0, 100.0)
		death_meter.value = death_value
		
		if death_value >= 100.0:
			game_over()

func _physics_process(delta: float) -> void:
	if burning:
		player.apply_central_force(
			player.linear_velocity.rotated(PI) * 5.0
		)

func game_over() -> void:
	MainCam.shake(30, 60, 5)
	game_overed = true
	player.die()
	game_ended.emit()
	
	await get_tree().create_timer(1.0, false).timeout
	retry_butt.show()
	menu_butt.show()

func _on_player_burnt() -> void:
	burning = true


func _on_player_unburnt() -> void:
	burning = false


func _on_wave_handler_enemy_killed(enemy: Node2D) -> void:
	death_value -= 5.0


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	pass # Replace with function body.
