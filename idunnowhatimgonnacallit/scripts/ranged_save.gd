extends Node2D

@onready var rangedweaponunlock: Area2D = $ranged_weapon_unlock

func _ready() -> void:
	GameManager.update_time_left(false)
	if GameManager.upgrades[0]:
		rangedweaponunlock.visible = false
		rangedweaponunlock.monitoring = false
		


func _on_exit_area_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 2
	get_tree().change_scene_to_file("res://scenes/areas/first_area.tscn")
	pass # Replace with function body.


func _on_ranged_weapon_unlock_body_entered(_body: Node2D) -> void:
	GameManager.upgrades[0] = true
	GameManager.send_ammo_status()
	rangedweaponunlock.visible = false
	rangedweaponunlock.monitoring = false
	pass # Replace with function body.
