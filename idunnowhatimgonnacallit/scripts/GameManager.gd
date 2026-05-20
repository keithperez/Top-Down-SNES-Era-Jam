extends Node

signal player_health_updated(newHealth: int, maxHealth: int)
signal player_ammo_counter(currentAmmoCount: int, unlocked: bool)

@export var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth
var Ammo: int = 10

var keys: Array[bool] = [false, false, false] # the three keys to open the final boss door
var upgrades: Array[bool] = [false, true, false, false, false] # 5 upgrades from what i can think
# 0) better attack
# 1) ranged attack
# 2) give dash or upgrading dash
# 3) soul sucking ability?
# 4) idk

func update_player_health(newHealth: int, maxHealth: int):
	PlayerHealth = newHealth
	PlayerMaxHealth = maxHealth
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func send_health_status():
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func player_take_damage(damage: int):
	PlayerHealth -= damage
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func send_ammo_status():
	emit_signal("player_ammo_counter", Ammo, upgrades[1])
	
func update_ammo_count(ammo: int):
	Ammo += ammo
	emit_signal("player_ammo_counter", Ammo, upgrades[1])
	
	
	
