extends CharacterBody2D


const SPEED: float = 300.0
const NULLVECTOR: Vector2 = Vector2(0, 0)

var damage: int = 7
var swordSwinging: bool = false

@onready var swordAnimation: AnimatedSprite2D = $sword_pivot/sword_swing_anim
@onready var swordCollider: Area2D = $sword_pivot/sword_hitbox

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
		rotation = direction.angle() - (PI/2)
		lastDirection = direction
		velocity = direction * SPEED
		move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		if !swordSwinging:
			swordSwinging = true
			do_damage()
			swordAnimation.play()
			swordAnimation.visible = true


func _on_sword_swing_anim_animation_finished() -> void:
	swordAnimation.visible = false
	swordSwinging = false
	pass

func do_damage() -> void:
	for body in swordCollider.get_overlapping_bodies():
		body.take_damage(damage)
