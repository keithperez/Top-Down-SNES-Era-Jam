class_name DebugEnemy
extends Enemy

@onready var hpBar = $HealthBar

func _ready() -> void:
	hpBar.visible = false
	health = 10
	speed = 100
	knockback_speed = 200
	damage = 10

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func move_towards(other_position: Vector2) -> void:
	direction = Vector2(other_position.x - position.x, other_position.y - position.y).normalized()
	velocity = direction * speed

func take_damage(incoming_damage: int) -> void:
	hpBar.visible = true
	health -= incoming_damage
	hpBar.value = health
	if health <= 0:
		queue_free()
	velocity = -direction * knockback_speed

func _on_hurt_box_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
	pass # Replace with function body.
