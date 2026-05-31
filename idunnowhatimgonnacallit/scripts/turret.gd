class_name Turret
extends CharacterBody2D


const TURN_RATE: int = 3
const TIME_TO_AIM: int = 100 # physic frames until it shoots
const TIME_TO_SHOOT: int = 50
const TIME_TO_RELOAD: int = 75

@export var projectile_scene: PackedScene

var currentdelta: float = 0
var rotateTowards: float = 0.0
var firingSequence: bool = false
var reloading: bool = false

@onready var sprite = $AnimatedSprite2D
@onready var head = $turret_head

@onready var aimTimer: Timer = $aiming_time
@onready var shootingTimer: Timer = $shooting_time
@onready var reloadingTimer: Timer = $reloading_time

func _ready() -> void:
	aimTimer.start()

func _physics_process(delta: float) -> void:
	if !firingSequence and !reloading:
		rotation = rotate_toward(rotation, rotateTowards, TURN_RATE * delta)

func rotate_to(player_pos: Vector2) -> void:
	rotateTowards = position.angle_to_point(player_pos)
	
func fire() -> void:
	var proj = projectile_scene.instantiate()
	proj.direction = Vector2.from_angle(rotation)
	proj.rotation = rotation
	proj.position = position
	get_tree().root.add_child(proj)


func _on_aiming_time_timeout() -> void:
	firingSequence = true
	shootingTimer.start()
	pass # Replace with function body.

func _on_shooting_time_timeout() -> void:
	fire()
	sprite.play()
	head.visible = false
	reloading = true
	firingSequence = false
	reloadingTimer.start()
	pass # Replace with function body.

func _on_reloading_time_timeout() -> void:
	reloading = false
	head.visible = true
	aimTimer.start()
	sprite.stop()
	pass # Replace with function body.
