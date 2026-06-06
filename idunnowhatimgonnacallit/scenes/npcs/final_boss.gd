class_name FinalBoss
extends Boss

const STRAFESPEED: int = 200

var circle_color: Color = Color(255, 251, 0, 0.4)

var drawShield: bool = false

var whatishedoing: String = "idling"
# idle into strafing into doing an action (shotgun, stakes, dashing)
var actiondoing: String = "n/a" # n/a (nothing), shotgun, stakes, dashing


var strafeAction: int = 0

var bossPissed: bool = true

var idleWaitTime: float = 2.0
var strafingWaitTime: float = 3.0

var shotgunAimTime: float = 3.0
var shotgunShootTime: float = 1.5
var isAimingShotgun: bool = false

var stakeAimTime: float = 1.0

var dashingAimTime: float = 2.0
var dashingGoTime: float = 1.0
var dashingTime: float = 0.5
var dashingActions: int = 0
# 0 for aiming, 1 for preparing to dash, 2 for actually dashing
const DASHSPEED: float = 1500.0

var actionsDone: int = 0

@export var projectile_pellet: PackedScene
@export var projectile_stake: PackedScene

@onready var shotgun: Sprite2D = $shotgun
@onready var shotgunTip: Node2D = $shotgun_tip
@onready var generalTimer: Timer = $GeneralTimer
@onready var dashwarning: ColorRect = $dashing_warning
@onready var stakewarning: Node2D = $stake_warning
@onready var hat: Sprite2D = $hat

@onready var innerHitbox: Area2D = $hitbox

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	drawShield = false
	boss_name = "Steve, Annihilator of Vampires"
	health = 1250
	speed = 300.0
	GameManager.connect("boss_pissed", _on_boss_pissed)
	pass
	
# i would love to use this but i need to be able to pass in the player's position
func _physics_process(_delta: float) -> void:
	for body in innerHitbox.get_overlapping_bodies():
		body.take_damage(15)
	
func handle_everything(playerPosition: Vector2) -> void:
	match whatishedoing:
		"idling":
			look_toward(playerPosition)
		"strafing":
			match strafeAction:
				0: # ccw
					look_toward(playerPosition)
					lastDirection = Vector2.from_angle(rotation + PI/2)
					velocity = lastDirection * STRAFESPEED 
				1: # straight
					look_toward(playerPosition)
					velocity = lastDirection * STRAFESPEED * 0.75 # guy is so fast w/o this
				2: # cw
					look_toward(playerPosition)
					lastDirection = Vector2.from_angle(rotation - PI/2)
					velocity = lastDirection * STRAFESPEED
		"action":
			match actiondoing:
				"shotgun":
					if isAimingShotgun:
						keep_within_distance(playerPosition, 250.0, 600.0)
					else:
						velocity = Vector2.ZERO
				"stakes":
					look_toward(playerPosition)
					pass
				"dashing":
					if dashingActions == 0:
						look_toward(playerPosition)
					elif dashingActions == 2:
						velocity = lastDirection * DASHSPEED
					pass
		_:
			whatishedoing = "idling" # it's impossible for it to get to this point so let's throw the boss back into idling
	move_and_slide()
func set_strafing_activity() -> void:
	strafeAction = rng.randi_range(0, 2)
	# 0 goes counter-clock-wise
	# 1 goes straight to player
	# 2 goes clock-wise
	
func set_action() -> void:
	match rng.randi_range(0,2):
		0:
			actiondoing = "shotgun"
		1:
			actiondoing = "stakes"
		2:
			actiondoing = "dashing"
	
func start_boss_timer() -> void:
	generalTimer.start()
	
func keep_within_distance(pos: Vector2, distance_close: float, distance_far: float) -> void:
	look_toward(pos)
	if position.distance_to(pos) < distance_close:
		velocity = lastDirection * speed * 0.80
	elif position.distance_to(pos) > distance_far:
		velocity = lastDirection * speed
	else:
		velocity = Vector2.ZERO
	
	
	
func _on_general_timer_timeout() -> void:
	match whatishedoing:
		"idling":
			generalTimer.start(strafingWaitTime - (float(bossPissed) * strafingWaitTime * 0.5))
			set_strafing_activity()
			whatishedoing = "strafing"
			print("going to strafing")
		"strafing":
			velocity = Vector2.ZERO
			whatishedoing = "action"
			set_action()
			match actiondoing:
				"shotgun":
					generalTimer.start(shotgunAimTime - (float(bossPissed) * shotgunAimTime * 0.5))
					isAimingShotgun = true
					shotgun.visible = true
				"stakes":
					generalTimer.start(stakeAimTime - (float(bossPissed) * stakeAimTime * 0.25))
					stakewarning.visible = true
				"dashing":
					generalTimer.start(dashingAimTime - (float(bossPissed) * dashingAimTime * 0.25))
					dashwarning.visible = true
		"action":
			match actiondoing:
				"shotgun":
					handle_shotgun()
				"stakes":
					handle_stakes()
				"dashing":
					handle_dashing()
			if whatishedoing == "idling":
				print("going to idling")
				generalTimer.start(idleWaitTime - (float(bossPissed) * idleWaitTime * 0.5))

func handle_shotgun() -> void:
	if isAimingShotgun: # after the timing for the aiming is over
		isAimingShotgun = false
		generalTimer.start(shotgunShootTime)
	else: # if the timing for the thing to shoot goes off
		shoot_shotgun(10 + (int(bossPissed) * 10))
		actionsDone += 1
		isAimingShotgun = true
		if actionsDone > 3:
			whatishedoing = "idling"
			actionsDone = 0
			shotgun.visible = false
		else:
			generalTimer.start(shotgunAimTime - (float(bossPissed) * shotgunAimTime * 0.5))

func handle_stakes() -> void:
	shoot_stake()
	actionsDone += 1
	if actionsDone > 6:
		whatishedoing = "idling"
		actionsDone = 0
		stakewarning.visible = false
	else:
		generalTimer.start(stakeAimTime - (float(bossPissed) * stakeAimTime * 0.5))

func handle_dashing() -> void:
	match dashingActions:
		0: # aim dash
			generalTimer.start(dashingGoTime - (float(bossPissed) * dashingGoTime * 0.5))
			dashingActions = 1
			dashwarning.visible = true
		1: # prepare to dash
			generalTimer.start(dashingTime + (float(bossPissed)) * dashingTime * 0.5)
			dashingActions = 2
			dashwarning.visible = false
		2: # actually dash
			actionsDone += 1
			velocity = Vector2.ZERO
			dashingActions = 0
			dashwarning.visible = true
			if actionsDone > 2:
				whatishedoing = "idling"
				actionsDone = 0
				dashwarning.visible = false
			else:
				generalTimer.start(dashingAimTime - (float(bossPissed) * dashingAimTime * 0.5))


func _draw() -> void:
	if drawShield:
		draw_shield(500)
	queue_redraw()
	
func shoot_shotgun(pellets: int) -> void:
	for i in range(pellets):
		var proj = projectile_pellet.instantiate()
		proj.direction = Vector2.from_angle(rotation + rng.randf_range(-1, 1))
		proj.rotation = rotation
		proj.position = shotgunTip.global_position
		get_tree().root.add_child(proj)
	pass
	
func shoot_stake() -> void:
	var proj = projectile_stake.instantiate()
	proj.direction = Vector2.from_angle(rotation)
	proj.rotation = rotation
	proj.position = position
	get_tree().root.add_child(proj)
	pass
	
func draw_shield(radius: float) -> void:
	draw_circle(Vector2.ZERO, radius, circle_color)


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(20)
	pass # Replace with function body.
	
func _on_boss_pissed() -> void:
	if !bossPissed:
		bossPissed = true
		hat.visible = false
