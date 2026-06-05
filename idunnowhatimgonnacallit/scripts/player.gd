class_name Player
extends CharacterBody2D

const SPEED: float = 300.0
const DODGE_SPEED: float = 1000.0
const BACKSTEP_SPEED: float = 800.0
const NULLVECTOR: Vector2 = Vector2(0, 0)

var rng = RandomNumberGenerator.new()

var damage: int = 7
var swordSwinging: bool = false
var immune: bool = false
var dodging: bool = false
var canDodge: bool = true

@onready var swordAnimation: AnimatedSprite2D = $sword_pivot/sword_swing_anim
@onready var swordCollider: Area2D = $sword_pivot/sword_hitbox
@onready var iFrameTimer: Timer = $hit_immunity_timer
@onready var dodgeTimer: Timer = $dodge_time
@onready var dodgeCooldown: Timer = $dodge_cooldown_timer
@onready var knockbackTimer: Timer = $knocked_back_timer
@onready var cape: Sprite2D = $cape

@export var projectile_scene: PackedScene

var lastDirection: Vector2 = Vector2(0,1)

func _ready():
	swordAnimation.stop() # make sure it doesn't play all the way when the game loads
	GameManager.send_health_status()
	GameManager.send_ammo_status()
	if GameManager.upgrades[1]:
		swordAnimation.animation = "new_animation_1"
		damage = 14
		swordAnimation.scale = Vector2(2.25, 2.25)
		swordCollider.scale = Vector2(1.5, 1.5)
	if GameManager.upgrades[2]:
		cape.texture = preload("res://assets/upgraded_cape.png")
		dodgeCooldown.wait_time = 0.75
		dodgeTimer.wait_time = 0.25
		pass
	pass

func _physics_process(_delta: float) -> void:
	
	# iframe stuff
	if immune:
		if visible:
			visible = false
		else:
			visible = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if dodging:
		move_and_slide()
	elif direction != NULLVECTOR:
		if abs(direction.x) > abs(direction.y):
			lastDirection = Vector2(direction.x, 0).normalized()
		else:
			lastDirection = Vector2(0, direction.y).normalized()
		rotation = direction.angle() - (PI/2)
		lastDirection = direction.normalized()
		velocity = lastDirection * SPEED
		move_and_slide()
	
	if Input.is_action_pressed("attack"):
		if !swordSwinging:
			swordSwinging = true
			do_damage()
			swordAnimation.play()
			swordAnimation.visible = true
	
	if canDodge and !dodging:
		if Input.is_action_just_pressed("dash"):
			dodging = true
			velocity = lastDirection * DODGE_SPEED
			dodgeTimer.start()
			canDodge = false
		if Input.is_action_just_pressed("backstep"):
			dodging = true
			velocity = -lastDirection * BACKSTEP_SPEED
			dodgeTimer.start()
			canDodge = false
	
	if Input.is_action_just_pressed("shoot") and GameManager.Ammo > 0 and GameManager.upgrades[0]:
		shoot_proj()


func _on_sword_swing_anim_animation_finished() -> void:
	swordAnimation.visible = false
	swordSwinging = false
	pass

func do_damage() -> void:
	for body in swordCollider.get_overlapping_bodies():
		body.take_damage(damage)
		if GameManager.upgrades[4]:
			GameManager.player_take_damage(-2)
		# heal some

func shoot_proj() -> void:
	var proj = projectile_scene.instantiate()
	proj.direction = Vector2.from_angle(rotation + PI/2 + rng.randf_range(-0.1, 0.1))
	proj.rotation = rotation
	proj.position = position
	get_tree().root.add_child(proj)
	GameManager.update_ammo_count(-1)

func take_damage(incoming_damage: int) -> void:
	if !immune:
		GameManager.player_take_damage(incoming_damage)
		immune = true
		iFrameTimer.start()

func knocked_back(knockback_speed: float) -> void:
	dodging = true
	velocity = knockback_speed * -lastDirection
	knockbackTimer.start()
	

func _on_hit_immunity_timer_timeout() -> void: 
	immune = false
	visible = true

func _on_dodge_time_timeout() -> void:
	dodging = false
	velocity = NULLVECTOR
	dodgeCooldown.start()
	cape.visible = false

func _on_dodge_cooldown_timer_timeout() -> void:
	canDodge = true
	cape.visible = true

func _on_knocked_back_timer_timeout() -> void:
	dodging = false
	velocity = NULLVECTOR


func _on_activate_boss_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
