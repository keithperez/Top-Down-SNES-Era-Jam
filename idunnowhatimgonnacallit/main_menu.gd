extends Control


func _on_play_game_button_pressed() -> void:
	GameManager.reset_everything()
	get_tree().change_scene_to_file("res://scenes/areas/first_save.tscn")
	pass # Replace with function body.
