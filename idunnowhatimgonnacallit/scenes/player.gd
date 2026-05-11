extends CharacterBody2D


const SPEED: float = 300.0


func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED

	move_and_slide()
