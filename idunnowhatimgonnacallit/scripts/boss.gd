# This is like the base for 
class_name Boss
extends CharacterBody2D

var speed: float = 150.0
var health: int
var lastDirection: Vector2 = Vector2(1, 0)
var boss_name: String

var dashing: bool = false
@onready var dashTimer: Timer
var dashingDamage: int

var shouldMove: bool
var doingAction: bool

var activated: bool = false

func take_damage(incoming_damage: int) -> void:
	GameManager.boss_takes_damage(incoming_damage, -1)

func look_toward(pos: Vector2) -> void:
	lastDirection = position.direction_to(pos)
	rotation = position.angle_to_point(pos)

func keep_distance_from(pos: Vector2, distance: float) -> void:
	if shouldMove:
		look_toward(pos)
		var remainingDistanceFromPos = distance - position.distance_to(pos)
		if remainingDistanceFromPos <= 0: # if we are too far from pos, move toward it
			velocity = lastDirection * speed
		else: # move away
			velocity = -lastDirection * speed
		
func dash(input_speed: float, how_long: float) -> void:
	velocity = lastDirection * input_speed
	dashTimer.wait_time = how_long
	dashTimer.start()
	dashing = true

func _on_dash_timer_timeout():
	dashing = false
	velocity = Vector2(0,0)
