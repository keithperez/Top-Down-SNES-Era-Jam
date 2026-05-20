extends Control

@onready var healthBar: ProgressBar = $CanvasLayer/health_bar
@onready var ammoCounter: TextureRect = $CanvasLayer/ammo_count
@onready var ammoCounterText: Label = $CanvasLayer/ammo_count/ammo_count_number

func _ready() -> void:
	GameManager.connect("player_health_updated", _on_player_health_update)
	GameManager.connect("player_ammo_counter", _on_player_ammo_update)

func _on_player_health_update(current: int, _max: int):
	healthBar.value = current

func _on_player_ammo_update(ammo: int, unlocked: bool):
	if unlocked:
		ammoCounter.visible = true
		ammoCounterText.text = str(ammo)
	else:
		ammoCounter.visible = false
