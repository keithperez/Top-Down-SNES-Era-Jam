extends Node

signal player_health_updated(newHealth: int, maxHealth: int)
signal player_ammo_counter(currentAmmoCount: int, unlocked: bool)
signal boss_health_bar_update(bossHealth: int, bossMaxHealth: int)
signal boss_health_bar_exists(bossMaxHealth: int, bossName: String)

@export var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth
var Ammo: int = 10

var BossHealth: int = -1 # basically just there is no boss
var BossMaxHealth: int = -1 # also the check

var keys: Array[bool] = [false, false, false] # the three keys to open the final boss door
var upgrades: Array[bool] = [false, true, false, false, false] # 5 upgrades from what i can think
# 0) better attack
# 1) ranged attack
# 2) increased length on player dodge
# 3) soul sucking ability?
# 4) iFrames on dodging


func update_player_health(newHealth: int, maxHealth: int) -> void:
	PlayerHealth = newHealth
	PlayerMaxHealth = maxHealth
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func send_health_status() -> void:
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func player_take_damage(damage: int) -> void:
	PlayerHealth -= damage
	emit_signal("player_health_updated", PlayerHealth, PlayerMaxHealth)

func send_ammo_status() -> void:
	emit_signal("player_ammo_counter", Ammo, upgrades[1])
	
func update_ammo_count(ammo: int) -> void:
	Ammo += ammo
	emit_signal("player_ammo_counter", Ammo, upgrades[1])
	
func boss_exists(maxHealth: int, bossName: String) -> void:
	BossMaxHealth = maxHealth
	BossHealth = maxHealth
	emit_signal("boss_health_bar_exists", maxHealth, bossName)

func boss_takes_damage(damage: int) -> void:
	BossHealth -= damage
	emit_signal("boss_health_bar_update", BossHealth, BossMaxHealth)
	
	
