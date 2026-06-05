class_name FinalBoss
extends Boss

var circle_color: Color = Color(255, 251, 0, 0.4)

var drawShield: bool = false

var whatishedoing: String = "idling"
# idle into strafing into doing an action (shotgun, stakes, dashing)
var actiondoing: String = "n/a" # n/a (nothing), shotgun, stakes, dashing

@export var projectile_pellet: PackedScene
@export var projectile_stake: PackedScene

@onready var shotgunTip: Node2D = $shotgun_tip

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	drawShield = false
	boss_name = "Steve, Annihilator of Vampires"
	health = 1000
	pass
	
# i would love to use this but i need to be able to pass in the player's position
func _physics_process(_delta: float) -> void:
	pass
	
func handle_everything(playerPosition: Vector2) -> void:
	match whatishedoing:
		"idling":
			look_toward(playerPosition)
		"strafing":
			pass
		"action":
			pass
		_:
			whatishedoing = "idling" # it's impossible for it to get to this point so let's throw the boss back into idling
	

	
	
	
	
	
	
	
	
	
	
func _draw() -> void:
	if drawShield:
		draw_shield(500)
	queue_redraw()
	
func shoot_shotgun(pellets: int) -> void:
	for i in range(pellets):
		var proj = projectile_pellet.instantiate()
		proj.direction = Vector2.from_angle(rotation + PI/2 + rng.randf_range(-1, 1))
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
