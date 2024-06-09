extends FlasherState

const BEAM = preload("res://light_beam/light_beam.tscn")

@export var chase_speed: float = 100.0
@export var turn_speed: float = 5.0
@export var light_point: Marker2D
@export var chase_sound: AudioStreamPlayer

var beam: LightBeam

func enter(_msg:={}) -> void:
	chase_sound.play()
	
	beam = BEAM.instantiate()
	beam.start_width = 8.0
	beam.end_width = 64.0
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

func exit() -> void:
	chase_sound.stop()

func _on_flasher_smashed() -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
