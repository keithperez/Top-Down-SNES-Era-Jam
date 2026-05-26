class_name DebugBoss
extends Boss

const SWING_WINDUP_SPEED: float = 100.0

@onready var animationplayer: AnimationPlayer = $AnimationPlayer
@onready var windupTimer: Timer = $timers_section/windup_timer

var shouldMove: bool = true

func _ready() -> void:
	health = 300
	boss_name = "The Bottomed Orge"
	GameManager.boss_exists(health, boss_name)
	doingAction = false
	dashTimer = $timers_section/dash_timer
	dashingDamage = 20
	

func _physics_process(_delta: float) -> void:
	if !doingAction:
		start_swing()
	if shouldMove:
		move_and_slide()
	pass

# the whole start_swing process
func start_swing() -> void:
	doingAction = true
	animationplayer.play("orc_swing_startup")
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "orc_swing_startup":
		windupTimer.start()
		shouldMove = false
	elif anim_name == "orc_swinging":
		animationplayer.play("RESET")
		doingAction = false
		shouldMove = true
	pass # Replace with function body.


func _on_windup_timer_timeout() -> void:
	animationplayer.play("orc_swinging")
	pass # Replace with function body.
