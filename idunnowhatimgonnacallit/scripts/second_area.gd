extends Node2D

@onready var player: Player = $Player
@onready var upgrade: Area2D = $to_upgrade
@onready var upgrade2: Area2D = $ammo_upgrade

@onready var groupOne: Node = $groups_of_enemies/first_group
@onready var groupTwo: Node = $groups_of_enemies/second_group
@onready var groupSecret: Node = $groups_of_enemies/secret_group

@onready var attackupgrade: Area2D = $bigger_badder_sword
@onready var playerswordanimation: AnimatedSprite2D = $Player/sword_pivot/sword_swing_anim
@onready var swordCollision: CollisionShape2D = $bigger_badder_sword/CollisionShape2D
@onready var capeupgrade: Area2D = $faster_cape

var grouponeActive: bool = false

var grouptwoActive: bool = false

var groupsecretActive: bool = false
var framessincelastupdate: int = 0


func _ready() -> void:
	GameManager.update_time_left(false)
	GameManager.notify_player("Area Two")
	if GameManager.playerSpawn == 1:
		player.position = $spawn_points/spawn_point1.position
	elif GameManager.playerSpawn == 2:
		player.position = $spawn_points/spawn_point2.position
	elif GameManager.playerSpawn == 3:
		player.position = $spawn_points/spawn_point3.position
	if GameManager.upgrades[1]:
		attackupgrade.visible = false
		attackupgrade.monitoring = false
	if GameManager.upgrades[2]:
		capeupgrade.visible = false
		capeupgrade.monitoring = false
	if GameManager.upgrades[4]:
		upgrade.visible = false
		upgrade.monitoring = false
	if GameManager.upgrades[3]:
		upgrade2.visible = false
		upgrade2.monitoring = false

func _physics_process(_delta: float) -> void:
	if grouponeActive:
		for thing in groupOne.get_children():
			if is_instance_of(thing, Enemy):
				thing.direct_towards(player.position)
				thing.move_and_slide()
			else:
				thing.rotate_to(player.position)
		pass
	if grouptwoActive:
		for enemy in groupTwo.get_children():
			enemy.direct_towards(player.position)
			enemy.move_and_slide()
		pass
	if groupsecretActive:
		for enemy in groupSecret.get_children():
			enemy.direct_towards(player.position)
			enemy.move_and_slide()
		pass
	pass

# transition back to maze thing
func _on_back_to_transition_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 2
	get_tree().change_scene_to_file("res://scenes/areas/transition_to_area_2.tscn")
	pass # Replace with function body.

# upgrade to blood blade
func _on_to_upgrade_body_entered(_body: Node2D) -> void:
	GameManager.upgrades[4] = true
	GameManager.notify_player("Main attack now heals you upon hitting enemies!")
	upgrade.visible = false
	upgrade.monitoring = false
	pass # Replace with function body.

# transition to the final boss
func _on_to_final_boss_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/areas/final_safe_area.tscn")
	pass # Replace with function body.


func _on_ammo_upgrade_body_entered(_body: Node2D) -> void:
	if !GameManager.upgrades[0]:
		GameManager.notify_player("Unlock the first bat upgrade first!")
	else:
		GameManager.upgrades[3] = true
		GameManager.notify_player("Max bats has increased!")
		GameManager.MaxAmmo = 50
		GameManager.Ammo = 50
		upgrade2.visible = false
		upgrade2.monitoring = false
	pass # Replace with function body.


func _on_countdown_timer_timeout() -> void:
	GameManager.update_time_left(true)
	pass # Replace with function body.

# group activators
func _on_first_group_activator_body_entered(_body: Node2D) -> void:
	grouponeActive = true
	pass # Replace with function body.

func _on_second_group_activator_body_entered(_body: Node2D) -> void:
	grouptwoActive = true
	pass # Replace with function body.


func _on_secret_group_activator_body_entered(_body: Node2D) -> void:
	groupsecretActive = true
	pass # Replace with function body.


func _on_bigger_badder_sword_body_entered(_body: Node2D) -> void:
	GameManager.upgrades[1] = true
	attackupgrade.visible = false
	attackupgrade.monitoring = false
	playerswordanimation.animation = "new_animation_1"
	playerswordanimation.scale = Vector2(2.25, 2.25)
	swordCollision.scale = Vector2(1.5, 1.5)
	GameManager.notify_player("Main attack has been upgraded!")
	player.damage = 14
	# lowkey we don't have to update player damage here I don't have an enemy here anyway
	pass # Replace with function body.


func _on_faster_cape_body_entered(_body: Node2D) -> void:
	GameManager.upgrades[2] = true
	capeupgrade.visible = false
	capeupgrade.monitoring = false
	player.cape.texture = preload("res://assets/upgraded_cape.png")
	player.dodgeCooldown.wait_time = 0.75
	player.dodgeTimer.wait_time = 0.25
	GameManager.notify_player("Dodging lasts longer and cools down faster!")
	pass # Replace with function body.
