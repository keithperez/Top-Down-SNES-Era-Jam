extends Control

@onready var healthBar: ProgressBar = $CanvasLayer/health_bar
@onready var ammoCounter: TextureRect = $CanvasLayer/ammo_count
@onready var ammoCounterText: Label = $CanvasLayer/ammo_count/ammo_count_number
@onready var bossHealthBar: ProgressBar = $CanvasLayer/boss_health_bar
@onready var bossNametag: Label = $CanvasLayer/boss_health_bar/boss_name

func _ready() -> void:
	GameManager.connect("player_health_updated", _on_player_health_update)
	GameManager.connect("player_ammo_counter", _on_player_ammo_update)
	GameManager.connect("boss_health_bar_update", _on_boss_health_update)
	GameManager.connect("boss_health_bar_exists", _on_boss_existance)

func _on_player_health_update(current: int, _max: int) -> void:
	healthBar.value = current

func _on_player_ammo_update(ammo: int, unlocked: bool) -> void:
	if unlocked:
		ammoCounter.visible = true
		ammoCounterText.text = str(ammo)
	else:
		ammoCounter.visible = false

func _on_boss_health_update(bossHealth: int, bossMaxHealth: int) -> void:
	bossHealthBar.max_value = bossMaxHealth
	bossHealthBar.value = bossHealth

func _on_boss_existance(bossMaxHealth: int, bossName: String) -> void:
	bossHealthBar.visible = true
	bossNametag.text = bossName
	bossHealthBar.max_value = bossMaxHealth
	bossHealthBar.value = bossMaxHealth
	
