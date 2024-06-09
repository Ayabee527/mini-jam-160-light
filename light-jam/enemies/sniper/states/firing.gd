extends SniperState

var beam: LightBeam

func enter(msg:={}) -> void:
	if msg.has("beam"):
		beam = msg["beam"]
		
		await beam.finished
		if is_active:
			state_machine.transition_to("Tracking")
	else:
		state_machine.transition_to("Tracking")


func _on_smash_detect_area_entered(area: Area2D) -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
