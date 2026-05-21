# This is like the base for 
class_name Boss
extends CharacterBody2D

var speed: float = 150.0
var health: int
var lastDirection: Vector2 = Vector2(1, 0)
var boss_name: String

func take_damage(incoming_damage: int) -> void:
	GameManager.boss_takes_damage(incoming_damage)

func look_toward(pos: Vector2) -> void:
	lastDirection = position.direction_to(pos)
	rotation = position.angle_to_point(pos)
	
func keep_distance_from(pos: Vector2, distance: float) -> void:
	look_toward(pos)
	var remainingDistanceFromPos = distance - position.distance_to(pos)
	if remainingDistanceFromPos <= 0: # if we are too far from pos, move toward it
		velocity = lastDirection * speed
	else: # move away
		velocity = -lastDirection * speed
