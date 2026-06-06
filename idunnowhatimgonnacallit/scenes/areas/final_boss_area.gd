extends Node2D

var bossActive: bool = false

@onready var player: Player = $Player
@onready var boss: FinalBoss = $final_boss
@onready var second_timer: Timer = $second_timer
@onready var cam: Camera2D = $Player/Camera2D

func _ready() -> void:
	GameManager.update_time_left(false)
	GameManager.notify_player("Prepare yourself...")
	GameManager.connect("boss_died", _on_boss_death)

func _physics_process(_delta: float) -> void:
	if bossActive:
		boss.handle_everything(player.position)
		if cam.zoom.x > 0.6:
			cam.zoom.x -= 0.001
			cam.zoom.y -= 0.001

func _on_activate_boss_body_entered(_body: Node2D) -> void:
	if !bossActive:
		bossActive = true
		$activate_boss.monitoring = false
		$anti_leaving_mechanism.visible = true
		$anti_leaving_mechanism/CollisionShape2D.set_deferred("disabled", true)
		GameManager.boss_exists(boss.health, boss.boss_name)
		second_timer.start()
		boss.start_boss_timer()
		pass # Replace with function body.


func _on_second_timer_timeout() -> void:
	GameManager.update_time_left(true)
	pass # Replace with function body.
	
func _on_boss_death(_whichOne: int) -> void:
	get_tree().change_scene_to_file("res://scenes/you_win_screen.tscn")
	pass
