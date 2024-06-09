extends Control

@export var quit_butt: Button

@export var last_score_label: Label
@export var high_score_label: Label

func _ready() -> void:
	SceneSwitcher.switch_in()
	SaveHandler.load_config()
	
	load_scores()
	
	if OS.has_feature("web"):
		quit_butt.hide()

func load_scores() -> void:
	last_score_label.text = "LAST " + biggen_score(Global.latest_score)
	high_score_label.text = biggen_score(Global.high_score) + " HIGH"

func biggen_score(score: int) -> String:
	var total_digits = 6
	var missing_digits = total_digits - str(score).length()
	
	if missing_digits < 1:
		return str(score)
	
	var biggened_score := ""
	for digit in missing_digits:
		biggened_score += "0"
	biggened_score += str(score)
	
	return biggened_score

func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
