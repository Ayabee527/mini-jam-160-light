extends Camera2D

@export var default_shake_speed: float = 15.0
@export var default_shake_strength: float = 4.0
@export var default_decay_rate: float = 5.0

var noise_i: float = 0.0
var shake_strength: float = 0.0
var shake_speed: float
var shake_decay_rate: float

var target: Node2D

@onready var rng = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

func _ready() -> void:
	rng.randomize()
	noise.seed = rng.randi()
	noise.frequency = 2.0

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position
	
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	offset = get_noise_offset(delta)

func shake(strength: float = 0.0, speed: float = 0.0, decay: float = 0.0) -> void:
	if strength != 0.0:
		shake_strength = strength
	else:
		shake_strength = default_shake_strength
	
	if speed != 0.0:
		shake_speed = speed
	else:
		shake_speed = default_shake_speed
	
	if decay != 0.0:
		shake_decay_rate = decay
	else:
		shake_decay_rate = default_decay_rate

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * shake_speed
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength,
	)

func hitstop(time_scale: float, duration : float) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale, false).timeout
	Engine.time_scale = 1
