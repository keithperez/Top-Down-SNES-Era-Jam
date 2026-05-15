extends CharacterBody2D

var health = 10
const SPEED = 150
var direction: Vector2 = Vector2(0,0)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func move_towards(other_position: Vector2) -> void:
	direction = Vector2(other_position.x - position.x, other_position.y - position.y).normalized()
	velocity = direction * SPEED
	pass

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
