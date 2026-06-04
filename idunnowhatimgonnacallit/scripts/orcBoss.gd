class_name OrcBoss
extends Boss

const SWING_WINDUP_SPEED: float = 100.0

@onready var animationplayer: AnimationPlayer = $AnimationPlayer
@onready var windupTimer: Timer = $timers_section/windup_timer
@onready var actionCooldownTimer: Timer = $action_cooldown
@onready var bat_hitbox: Area2D = $arm_pivot/arm_attack

var canDoAction: bool = true

var distance: float = true

func _ready() -> void:
	health = 300
	boss_name = "The Bottomed Orge"
	doingAction = false
	dashTimer = $timers_section/dash_timer
	dashingDamage = 20
	GameManager.connect("boss_died", _boss_dead)

func take_damage(incoming_damage: int) -> void:
	GameManager.boss_takes_damage(incoming_damage, 0)

func _boss_dead() -> void:
	queue_free()
	pass

func _physics_process(_delta: float) -> void:
	if activated:
		if !doingAction and canDoAction:
			start_swing()
		if shouldMove:
			move_and_slide()

# the whole start_swing process
func start_swing() -> void:
	doingAction = true
	animationplayer.play("orc_swing_startup")
	pass

func boss_movement(otherPos: Vector2) -> void:
	if shouldMove:
		move_and_slide()
		keep_distance_from(otherPos, distance)
	distance += 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "orc_swing_startup":
		windupTimer.start()
		shouldMove = false
	elif anim_name == "orc_swinging":
		animationplayer.play("RESET")
		doingAction = false
		shouldMove = true
		canDoAction = false
		actionCooldownTimer.start()
		distance = 0
	pass # Replace with function body.


func _on_windup_timer_timeout() -> void:
	animationplayer.play("orc_swinging")
	pass # Replace with function body.


func _on_action_cooldown_timeout() -> void:
	canDoAction = true
	pass # Replace with function body.

func _on_arm_attack_body_entered(body: Node2D) -> void:
	body.take_damage(20)
	pass # Replace with function body.

func _on_getoffmehitbox_body_entered(body: Node2D) -> void:
	body.take_damage(5)
	pass # Replace with function body.
