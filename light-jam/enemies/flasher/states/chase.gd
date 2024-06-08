extends FlasherState

const BEAM = preload("res://light_beam/light_beam.tscn")

@export var chase_speed: float = 100.0
@export var turn_speed: float = 2.5
@export var light_point: Marker2D

var beam: LightBeam

func enter(_msg:={}) -> void:
	beam = BEAM.instantiate()
	#beam.global_position = light_point.global_position
	beam.charge_time = 2
	beam.sustain_time = 2
	light_point.add_child(beam)
	
	await beam.fired
	if is_active:
		state_machine.transition_to("Flash", {"beam": beam})

func physics_update(delta: float) -> void:
	var new_transform = enemy.transform.looking_at(enemy.player.global_position)
	enemy.transform = enemy.transform.interpolate_with(new_transform, turn_speed * delta)
	
	enemy.apply_central_force(
		Vector2.from_angle(enemy.global_rotation) * chase_speed
	)


func _on_flasher_smashed() -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
