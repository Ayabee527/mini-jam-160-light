class_name ScoreHandler
extends Node

const STYLE_TEXT = preload("res://style_text/style_text.tscn")

const STYLES = {
	"SLINGSHOT": 100,
	"CLEANSWEEP": 500,
	"SMASH": 50,
	"COMBO": 50,
	"COLLATERAL": 75,
	"STRAY": 100
}

@export var player: Player

@export var multiplier_label: Label
@export var score_label: Label

var speed_multiplier: float = 1.0
var score: int = 0:
	set = set_score
var last_score: int = 0

var clicks_in_wave: int = 0
var last_kill_clicks: int = 0

var last_grapple_target: Node2D
var grapple_target: Node2D

var kill_combo: int = 0

var burning: bool = false

func _process(delta: float) -> void:
	if burning:
		score -= 10
	
	if Input.is_action_just_pressed("left_click"):
		clicks_in_wave += 1
	
	if Input.is_action_just_released("left_click"):
		last_grapple_target = grapple_target
		grapple_target = null
	
	speed_multiplier = player.linear_velocity.length() / 150.0
	
	speed_multiplier = clamp(speed_multiplier, 1.0, 5.0)
	multiplier_label.text = "x" + str(snapped(speed_multiplier, 0.01))

func trigger_style(style: String) -> void:
	var split = style.split(" ")
	var style_name: String = split[0]
	var style_combo: int = 0
	if split.size() > 1:
		style_combo = split[1].to_int()
	
	if STYLES.has(style_name.to_upper()):
		var style_text = STYLE_TEXT.instantiate()
		style_text.style_text = style
		style_text.global_position = player.global_position
		get_tree().current_scene.add_child(style_text)
		
		if style_combo == 0:
			style_combo = 1
		
		score += ceili(STYLES[style_name.to_upper()] * style_combo * speed_multiplier)

func set_score(new_score: int = 0) -> void:
	score = max(0, new_score)
	
	var tween = create_tween()
	tween.tween_method(
		increment_score, last_score, score, 1.0
	)
	last_score = score

func increment_score(new_score: int):
	score_label.text = str(new_score)


func _on_wave_handler_enemy_killed(enemy: Node2D) -> void:
	var slingshot = false
	if last_grapple_target != null:
		slingshot = (
			last_grapple_target.owner.is_in_group("hook_points")
			and grapple_target == null
		)
	var stray = (
		grapple_target == null
		and clicks_in_wave == 0
	)
	var collateral = false
	if grapple_target != null:
		collateral = grapple_target.owner != enemy
	
	print(clicks_in_wave, ", ", last_kill_clicks, ", ", kill_combo)
	if (clicks_in_wave == last_kill_clicks):
		if kill_combo > 1:
			trigger_style("COMBO x" + str(kill_combo + 1))
		else:
			trigger_style("SMASH")
		kill_combo += 1
	else:
		trigger_style("SMASH")
		if kill_combo > 0:
			kill_combo = 0
		else:
			kill_combo += 1
	
	if slingshot:
		trigger_style("SLINGSHOT")
	elif stray:
		trigger_style("STRAY")
	elif collateral:
		trigger_style("COLLATERAL")
	
	last_kill_clicks = clicks_in_wave


func _on_wave_handler_wave_cleared(size: int) -> void:
	if not clicks_in_wave > 1:
		if size >= 5:
			trigger_style("CLEANSWEEP")
	clicks_in_wave = 0
	last_kill_clicks = 0


func _on_player_grappled(target: Node2D) -> void:
	if grapple_target != null:
		last_grapple_target = grapple_target
	grapple_target = target


func _on_player_burnt() -> void:
	burning = true


func _on_player_unburnt() -> void:
	burning = false
