extends SpotlightState

const BEAM = preload("res://light_beam/light_beam.tscn")

@export var beam_holder: Marker2D
@export var track_speed: float = 5.0

var beam: LightBeam

func enter(_msg:={}) -> void:
	spawn_beam()

func spawn_beam() -> void:
	beam = BEAM.instantiate()
	beam.start_width = 12.0
	beam.end_width = 128.0
	beam.charge_time = 1.0
	beam.sustain_time = 600.0
	beam_holder.add_child(beam)
	

func physics_update(delta: float) -> void:
	var new_transform = enemy.transform.looking_at(enemy.player.global_position)
	enemy.transform = enemy.transform.interpolate_with(new_transform, track_speed * delta)

func _on_smash_detect_area_entered(area: Area2D) -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
