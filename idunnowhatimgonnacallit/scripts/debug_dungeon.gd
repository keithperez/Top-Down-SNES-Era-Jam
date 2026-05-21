extends Node2D

const gameFramesPerUpdate: int = 5
var gameFramesPassed: int = 0
@onready var turrets = $turret_groups
@onready var player = $Player
@onready var boss = $debugBoss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.boss_exists(boss.health, boss.boss_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if (gameFramesPassed == gameFramesPerUpdate):
		for turret in turrets.get_children():
			turret.rotate_to(player.position)
		gameFramesPassed = 0
	else:
		gameFramesPassed += 1
	
	boss.keep_distance_from(player.position, 300.0)
