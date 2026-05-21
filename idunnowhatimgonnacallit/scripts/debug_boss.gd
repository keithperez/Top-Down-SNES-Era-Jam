class_name DebugBoss
extends Boss

func _ready() -> void:
	health = 300
	boss_name = "The Bottomed Orge"
	GameManager.boss_exists(health, boss_name)
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass
