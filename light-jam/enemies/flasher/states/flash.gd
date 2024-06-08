extends FlasherState

@export var recoil_speed: float = 10.0

var beam: LightBeam

var firing: bool = false

func enter(msg:={}) -> void:
	enemy.linear_velocity = Vector2.ZERO
	enemy.lock_rotation = true
	if msg.has("beam"):
		beam = msg["beam"]
		firing = true
		
		await beam.finished
		firing = false
		
		await beam.tree_exited
		if is_active:
			state_machine.transition_to("Chase")
	else:
		state_machine.transition_to("Chase")

func physics_update(delta: float) -> void:
	if firing:
		enemy.apply_central_force(
			Vector2.from_angle(enemy.global_rotation + PI) * recoil_speed
		)

func exit() -> void:
	enemy.lock_rotation = false


func _on_flasher_smashed() -> void:
	if is_active:
		beam.kill()
		state_machine.transition_to("Frozen", {"died": true})
