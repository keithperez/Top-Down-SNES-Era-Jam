class_name PlayerProjectile
extends Area2D

const SPEED: int = 500

var direction: Vector2 = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_projectile_lifetime_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Enemy) or is_instance_of(body, Boss):
		body.take_damage(10)
		queue_free()
	pass # Replace with function body.
