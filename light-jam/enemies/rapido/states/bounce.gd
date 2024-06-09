extends RapidoState

const BEAM = preload("res://light_beam/light_beam.tscn")

@export var fire_timer: Timer

@export var light_holder_1: Marker2D
@export var light_holder_2: Marker2D

var is_alt: bool = false

var beam_one: LightBeam = null
var beam_two: LightBeam = null

func enter(_msg:={}) -> void:
	fire_timer.start()

func exit() -> void:
	fire_timer.stop()

func fire_first() -> void:
	beam_one = BEAM.instantiate()
	beam_one.charge_time = 1.0
	beam_one.sustain_time = 1.0
	beam_two.end_width = 256
	light_holder_1.add_child(beam_one)

func fire_second() -> void:
	beam_two = BEAM.instantiate()
	beam_two.charge_time = 1.0
	beam_two.sustain_time = 1.0
	beam_two.end_width = 256
	light_holder_2.add_child(beam_two)

func _on_fire_timer_timeout() -> void:
	if is_alt:
		fire_first()
	else:
		fire_second()
	
	is_alt = not is_alt


func _on_smash_detect_area_entered(area: Area2D) -> void:
	if is_active:
		if beam_one != null:
			beam_one.kill()
		if beam_two != null:
			beam_two.kill()
		
		state_machine.transition_to("Frozen", {"died": true})
