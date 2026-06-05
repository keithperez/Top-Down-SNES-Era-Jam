extends Node2D

@onready var ponr: Area2D = $point_of_no_return_reminder

func _ready() -> void:
	GameManager.update_time_left(false)
	pass


func _on_point_of_no_return_reminder_body_entered(_body: Node2D) -> void:
	GameManager.notify_player("To the right is the point of no return, get ready!")
	ponr.monitoring = false
	pass # Replace with function body.


func _on_back_to_second_area_body_entered(_body: Node2D) -> void:
	GameManager.playerSpawn = 3
	get_tree().change_scene_to_file("res://scenes/areas/second_area.tscn")
	pass # Replace with function body.


func _on_to_final_boss_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/areas/final_boss_area.tscn")
	pass # Replace with function body.
