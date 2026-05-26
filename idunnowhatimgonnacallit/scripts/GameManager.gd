extends Node

signal player_health_updated(newHealth: int, maxHealth: int)
signal player_ammo_counter(currentAmmoCount: int, unlocked: bool)
signal boss_health_bar_update(bossHealth: int, bossMaxHealth: int)
signal boss_health_bar_exists(bossMaxHealth: int, bossName: String)

signal update_time(time: String)
signal notification(text: String)

var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth
var MaxAmmo: int = 10
var Ammo: int = 10

# in seconds
var timeLeft: int = 60 * 15

var BossHealth: int = -1 # basically just there is no boss
var BossMaxHealth: int = -1 # also the check

var keys: Array[bool] = [false, false, false] # the three keys to open the final boss door
var upgrades: Array[bool] = [false, false, false, false, false] # 5 upgrades from what i can think
# 0) better attack
# 1) ranged attack
# 2) increased length on player dodge
# 3) soul sucking ability?
# 4) iFrames on dodging

func update_time_left(removeSecond: bool) -> void:
	if removeSecond:
		timeLeft -= 1
	@warning_ignore("integer_division") # i want this :D
	emit_signal("update_time", str(timeLeft / 60) + ":" + "%02d" % (timeLeft % 60))
	

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
	
func notify_player(text: String) -> void:
	emit_signal("notification", text)
	
func restore_everything() -> void:
	PlayerHealth = PlayerMaxHealth
	Ammo = MaxAmmo
	send_health_status()
	send_ammo_status()
	
	
	
