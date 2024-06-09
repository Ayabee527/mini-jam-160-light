extends PanelContainer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused


func _on_unpause_pressed() -> void:
	get_tree().paused = false
	hide()
