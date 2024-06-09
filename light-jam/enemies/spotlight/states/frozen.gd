extends SpotlightState

func enter(msg:={}) -> void:
	if msg.has("died"):
		if msg["died"]:
			enemy.anim_player.play("die")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"spawn":
			if not enemy.dead:
				enemy.smash_detect.set_deferred("disabled", false)
				enemy.grapple.set_deferred("disabled", false)
				state_machine.transition_to("Target")
		"die":
			enemy.queue_free()
