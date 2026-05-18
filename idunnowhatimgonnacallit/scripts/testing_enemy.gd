class_name DebugEnemy
extends CharacterBody2D

const SPEED: int = 100
const KNOCKBACK_SPEED: int = 200
const DAMAGE: int = 5

var health: int = 10
var direction: Vector2 = Vector2(0,0)

@onready var hpBar = $HealthBar

func _ready() -> void:
	hpBar.visible = false

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func move_towards(other_position: Vector2) -> void:
	direction = Vector2(other_position.x - position.x, other_position.y - position.y).normalized()
	velocity = direction * SPEED

func take_damage(damage: int) -> void:
	hpBar.visible = true
	health -= damage
	hpBar.value = health
	if health <= 0:
		queue_free()
	velocity = -direction * KNOCKBACK_SPEED

func _on_hurt_box_body_entered(body: Node2D) -> void:
	body.take_damage(DAMAGE)
	pass # Replace with function body.
