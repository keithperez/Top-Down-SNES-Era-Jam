extends CharacterBody2D


const SPEED: float = 300.0
const NULLVECTOR: Vector2 = Vector2(0, 0)

@onready var swordAnimation: AnimatedSprite2D = $sword_pivot/sword_swing_anim
@onready var swordPivot: Node2D = $sword_pivot

var lastDirection: Vector2

func _ready():
	swordAnimation.stop() # make sure it doesn't play all the way when the game loads
	pass

func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction != NULLVECTOR:
		if abs(direction.x) > abs(direction.y):
			lastDirection = Vector2(direction.x, 0).normalized()
		else:
			lastDirection = Vector2(0, direction.y).normalized()
		lastDirection = direction
		velocity = direction * SPEED
		move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		swordPivot.rotation = direction.angle() - (PI/2)
		swordAnimation.play()
		swordAnimation.visible = true

func set_sword_direction(direction: Vector2) -> void:
	
	if direction == Vector2(1.0, 0.0):
		swordAnimation.rotation = -PI / 2
		swordAnimation.position = Vector2(position.x, position.y)
		#swordAnimation.position.x = position.x + 5
		#swordAnimation.position.y = position.y
		pass
	elif direction == Vector2(-1.0, 0.0):
		swordAnimation.rotation = -3 * PI / 2
		swordAnimation.position = Vector2(position.x, position.y)
		#swordAnimation.position.x = position.x - 5
		#swordAnimation.position.y = position.y
		pass
	elif direction == Vector2(0.0, 1.0):
		swordAnimation.rotation = 0
		swordAnimation.position = Vector2(position.x, position.y)
		pass
	elif direction == Vector2(0.0, -1.0):
		swordAnimation.rotation = PI
		swordAnimation.position = Vector2(position.x, position.y)
		#swordAnimation.position.x = position.x
		#swordAnimation.position.y = position.y + 5
		pass
	
	print("player pos: ", position)
	print("sword Anim pos: ", swordAnimation.position)

func _on_sword_swing_anim_animation_finished() -> void:
	swordAnimation.visible = false
	pass
