extends Node

signal player_health_updated(newHealth: int, maxHealth: int)

@export var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth

var upgrades: Array[bool] = [false, false, false, false, false] # 5 upgrades from what i can think

func update_player_health(newHealth: int, maxHealth: int):
	PlayerHealth = newHealth
	PlayerMaxHealth = maxHealth
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func send_health_status():
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func player_take_damage(damage: int):
	PlayerHealth -= damage
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)
