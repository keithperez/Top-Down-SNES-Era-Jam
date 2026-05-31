extends Node2D

func _ready() -> void:
	GameManager.update_time_left(false)
	
# from exit_area in first_save
func _on_exit_area_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 1
	get_tree().change_scene_to_file("res://scenes/areas/first_area.tscn")
	pass # Replace with function body.
