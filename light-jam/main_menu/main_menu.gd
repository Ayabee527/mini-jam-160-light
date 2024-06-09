extends Control

@export var quit_butt: Button

func _ready() -> void:
	if OS.has_feature("web"):
		quit_butt.hide()

func _on_play_pressed() -> void:
	SceneSwitcher.switch_to("res://main/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
