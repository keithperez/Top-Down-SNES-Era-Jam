extends Control

@onready var healthBar: ProgressBar = $CanvasLayer/health_bar

func _ready() -> void:
	GameManager.connect("player_health_updated", _on_player_health_update)

func _on_player_health_update(current: int, _max: int):
	healthBar.value = current
