extends Control

@onready var healthBar: ProgressBar = $CanvasLayer/health_bar
@onready var ammoCounter: TextureRect = $CanvasLayer/ammo_count
@onready var ammoCounterText: Label = $CanvasLayer/ammo_count/ammo_count_number
@onready var bossHealthBar: ProgressBar = $CanvasLayer/boss_health_bar
@onready var bossNametag: Label = $CanvasLayer/boss_health_bar/boss_name
@onready var timeLeftText: Label = $CanvasLayer/time
@onready var notificationText: Label = $CanvasLayer/notification_text
@onready var notificationTimer: Timer = $notification_timer

func _ready() -> void:
	GameManager.connect("player_health_updated", _on_player_health_update)
	GameManager.connect("player_ammo_counter", _on_player_ammo_update)
	GameManager.connect("boss_health_bar_update", _on_boss_health_update)
	GameManager.connect("boss_health_bar_exists", _on_boss_existance)
	GameManager.connect("notification", _on_notification)
	GameManager.connect("update_time", _on_time_update)
	GameManager.connect("boss_died", _boss_dead)

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
	
func _on_notification(text: String) -> void:
	notificationText.visible = true
	notificationText.text = text
	notificationTimer.start(text.length() * 0.3)
	
func _on_notification_timer_timeout() -> void:
	notificationText.visible = false

func _on_time_update(timeLeft: String) -> void:
	timeLeftText.text = timeLeft

func _boss_dead(_whichOne: int) -> void:
	bossHealthBar.visible = false
