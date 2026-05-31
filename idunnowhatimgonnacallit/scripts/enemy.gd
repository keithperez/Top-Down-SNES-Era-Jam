class_name Enemy
extends CharacterBody2D

var health: int
var speed: int
var knockback_speed: int
var damage: int
var direction: Vector2 = Vector2(1, 0)

func direct_towards(other_position: Vector2) -> void:
	direction = Vector2(other_position.x - position.x, other_position.y - position.y).normalized()

func take_damage(incoming_damage: int) -> void:
	health -= incoming_damage
	if health <= 0:
		queue_free()
	velocity = -direction * knockback_speed
