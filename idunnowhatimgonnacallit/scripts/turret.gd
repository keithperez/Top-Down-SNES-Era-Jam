extends CharacterBody2D


const TURN_RATE: int = 2
const TIME_TO_SHOOT: float = 3.0 # seconds

var rotateTowards: float = 0.0

func _physics_process(delta: float) -> void:
	rotation = rotate_toward(rotation, rotateTowards, TURN_RATE*delta)
	move_and_slide()

func rotate_to(player_pos: Vector2) -> void:
	rotateTowards = position.angle_to_point(player_pos)
	print(rotateTowards)
