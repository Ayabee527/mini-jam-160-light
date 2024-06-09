extends HookPointState

@export var respawn_timer: Timer

func enter(msg:={}) -> void:
	if msg.has("died"):
		if msg["died"]:
			hook_point.anim_player.play("die")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"spawn":
			hook_point.smash_detect.set_deferred("disabled", false)
			hook_point.grapple.set_deferred("disabled", false)
			state_machine.transition_to("Hover")
		"die":
			respawn_timer.start()
			await respawn_timer.timeout
			hook_point.anim_player.play("spawn")
