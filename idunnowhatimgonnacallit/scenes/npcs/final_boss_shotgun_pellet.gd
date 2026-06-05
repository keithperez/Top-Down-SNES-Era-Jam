class_name ShotgunPellet
extends CharacterBody2D

const SPEED: int = 1000

var direction: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = direction * SPEED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if is_instance_of(collider, Player):
			collider.take_damage(5)
			queue_free()
		elif is_instance_of(collider, TileMapLayer):
			queue_free()

func _on_projectile_lifetime_timeout() -> void:
	queue_free()
