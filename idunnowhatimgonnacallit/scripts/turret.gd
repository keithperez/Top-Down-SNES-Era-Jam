class_name Turret
extends CharacterBody2D


const TURN_RATE: int = 3
const TIME_TO_AIM: int = 100 # physic frames until it shoots
const TIME_TO_SHOOT: int = 50
const TIME_TO_RELOAD: int = 75

@export var projectile_scene: PackedScene

var currentdelta: int = 0
var rotateTowards: float = 0.0
var firingSequence: bool = false
var reloading: bool = false

@onready var sprite = $AnimatedSprite2D
@onready var head = $turret_head

func _physics_process(delta: float) -> void:
	if firingSequence:
		if currentdelta >= TIME_TO_SHOOT:
			currentdelta = 0
			firingSequence = false
			reloading = true
			fire()
			sprite.play()
			head.visible = false
	elif reloading:
		if currentdelta >= TIME_TO_RELOAD:
			currentdelta = 0
			reloading = false
			sprite.stop()
			head.visible = true
		pass
	else:
		rotation = rotate_toward(rotation, rotateTowards, TURN_RATE * delta)
		move_and_slide()
		if currentdelta >= TIME_TO_AIM:
			currentdelta = 0
			firingSequence = true
	currentdelta += 1

func rotate_to(player_pos: Vector2) -> void:
	rotateTowards = position.angle_to_point(player_pos)
	
func fire() -> void:
	var proj = projectile_scene.instantiate()
	proj.direction = Vector2.from_angle(rotation)
	proj.rotation = rotation
	proj.position = position
	get_tree().root.add_child(proj)
