extends Node2D

@onready var player: Player = $Player
@onready var boss: Boss = $orcBoss

var firstgroupactive: bool = false
var secondgroupactive: bool = false
var bossActive: bool = false

func _ready() -> void:
	GameManager.update_time_left(false)
	GameManager.connect("boss_died", _boss_dead)
	GameManager.notify_player("Area One")
	if GameManager.playerSpawn == 1:
		$Player.position = $spawn_points/spawn_point_1.position
	elif GameManager.playerSpawn == 2:
		$Player.position = $spawn_points/spawn_point_2.position
	elif GameManager.playerSpawn == 3:
		$Player.position = $spawn_points/spawn_point_3.position
	if GameManager.bossesDead[0]:
		boss.queue_free()
	
func _physics_process(_delta: float) -> void:
	if firstgroupactive:
		for enemy in $first_chunk_of_enemies.get_children():
			enemy.direct_towards(player.position)
			enemy.move_and_slide()
	if secondgroupactive:
		for turret in $second_chunk_of_enemies.get_children():
			turret.rotate_to(player.position)
	if bossActive and boss:
		boss.boss_movement(player.position)
	pass

func _on_second_timer_timeout() -> void:
	GameManager.update_time_left(true)

# getting through entrances I GUESS!!!
func _on_first_dungeon_entrance_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/areas/first_save.tscn")
	pass # Replace with function body.

func _on_ranged_dungeon_entrance_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/areas/ranged_save.tscn")
	pass # Replace with function body.

func _on_to_next_dungeon_entrance_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 1
	get_tree().change_scene_to_file("res://scenes/areas/transition_to_area_2.tscn")
	pass # Replace with function body.

# activating shit
func _on_first_group_activator_body_entered(_body: Node2D) -> void:
	firstgroupactive = true
	pass # Replace with function body.

func _on_second_group_activator_body_entered(_body: Node2D) -> void:
	secondgroupactive = true
	pass # Replace with function body.

func _on_boss_activate_body_entered(_body: Node2D) -> void:
	if !bossActive and !GameManager.bossesDead[0]:
		$boss_stoppers/boss_area_exit_stopper.visible = true
		$boss_stoppers/boss_area_exit_stopper/CollisionShape2D.set_deferred("disabled", false)
		$boss_stoppers/boss_area_dungeon_stopper.visible = true
		$boss_stoppers/boss_area_dungeon_stopper/CollisionShape2D.set_deferred("disabled", false)
		boss.activated = true
		firstgroupactive = false
		secondgroupactive = false
		bossActive = true
		GameManager.boss_exists(boss.health, boss.boss_name)
	pass # Replace with function body.

func _boss_dead(_whichOne: int) -> void:
	$boss_stoppers/boss_area_exit_stopper.visible = false
	$boss_stoppers/boss_area_exit_stopper/CollisionShape2D.set_deferred("disabled", true)
	$boss_stoppers/boss_area_dungeon_stopper.visible = false
	$boss_stoppers/boss_area_dungeon_stopper/CollisionShape2D.set_deferred("disabled", true)
	boss.queue_free()
	GameManager.notify_player("The boss has been defeated!")
	pass
