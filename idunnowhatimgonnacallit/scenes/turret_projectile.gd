class_name TurretProjectile
extends Area2D

const SPEED: int = 300

var direction: Vector2 = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_projectile_lifetime_timeout() -> void:
	queue_free()
