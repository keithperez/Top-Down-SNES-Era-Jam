extends Node2D

@onready var attackupgrade: Area2D = $bigger_badder_sword
@onready var playerswordanimation: AnimatedSprite2D = $Player/sword_pivot/sword_swing_anim
@onready var swordCollision: CollisionShape2D = $bigger_badder_sword/CollisionShape2D
@onready var capeupgrade: Area2D = $faster_cape

@onready var player: Player = $Player

func _ready() -> void:
	if GameManager.upgrades[1]:
		attackupgrade.visible = false
		attackupgrade.monitoring = false
	if GameManager.upgrades[2]:
		capeupgrade.visible = false
		capeupgrade.monitoring = false
	GameManager.update_time_left(false)
	if GameManager.playerSpawn == 1:
		player.position = $spawn_points/spawn_point_1.position
	elif GameManager.playerSpawn == 2:
		player.position = $spawn_points/spawn_point_2.position
	pass

func _on_bigger_badder_sword_body_entered(_body: Node2D) -> void:
	GameManager.upgrades[1] = true
	attackupgrade.visible = false
	attackupgrade.monitoring = false
	playerswordanimation.animation = "new_animation_1"
	playerswordanimation.scale = Vector2(2.25, 2.25)
	swordCollision.scale = Vector2(1.5, 1.5)
	GameManager.notify_player("Main attack has been upgraded!")
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


func _on_exit_to_first_area_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 3
	get_tree().change_scene_to_file("res://scenes/areas/first_area.tscn")
	pass # Replace with function body.


func _on_exit_to_second_area_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 1
	get_tree().change_scene_to_file("res://scenes/areas/second_area.tscn")
	pass # Replace with function body.
