extends Node2D

var bossActive: bool = false

@onready var player: Player = $Player
@onready var boss: FinalBoss = $final_boss
@onready var second_timer: Timer = $second_timer

func _ready() -> void:
	GameManager.update_time_left(false)
	GameManager.notify_player("Prepare yourself...")

func _physics_process(_delta: float) -> void:
	boss.handle_everything(player.position)

func _on_activate_boss_body_entered(_body: Node2D) -> void:
	bossActive = true
	$activate_boss.monitoring = false
	$anti_leaving_mechanism.visible = true
	$anti_leaving_mechanism/CollisionShape2D.set_deferred("disabled", false)
	GameManager.boss_exists(boss.health, boss.boss_name)
	second_timer.start()
	pass # Replace with function body.


func _on_second_timer_timeout() -> void:
	GameManager.update_time_left(true)
	pass # Replace with function body.
