extends SniperState

const BEAM = preload("res://light_beam/light_beam.tscn")

@export var barrel: Polygon2D
@export var beam_holder: Marker2D
@export var track_speed: float = 7.0

var beam: LightBeam

func enter(_msg:={}) -> void:
	beam = BEAM.instantiate()
	beam.end_width = 48
	beam.charge_time = 1.0
	beam.sustain_time = 2.0
	beam_holder.add_child(beam)
	
	await beam.fired
	state_machine.transition_to("Firing", {"beam": beam})

func physics_update(delta: float) -> void:
	var new_transform = enemy.transform.looking_at(enemy.player.global_position)
	enemy.transform = enemy.transform.interpolate_with(new_transform, track_speed * delta)


func _on_smash_detect_area_entered(area: Area2D) -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
