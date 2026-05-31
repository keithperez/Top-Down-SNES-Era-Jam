class_name basicEnemy
extends Enemy

@onready var hpBar = $HealthBar
@onready var sprite = $Sprite2D
@onready var timer = $knockback_timer

var knockedBack: bool = false

func _ready() -> void:
	hpBar.visible = false
	health = 10
	speed = 100
	knockback_speed = 300
	damage = 5

func _physics_process(_delta: float) -> void:
	sprite.rotation = direction.angle() - (PI/2)
	if knockedBack:
		velocity = -direction * knockback_speed
	else:
		velocity = direction * speed
		
func take_damage(incoming_damage: int) -> void:
	hpBar.visible = true
	health -= incoming_damage
	hpBar.value = health
	if health <= 0:
		queue_free()
	knockedBack = true
	set_collision_mask_value(2, false)
	timer.start()

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
	pass # Replace with function body.

func _on_knockback_timer_timeout() -> void:
	knockedBack = false
	set_collision_mask_value(2, true)
	pass # Replace with function body.
