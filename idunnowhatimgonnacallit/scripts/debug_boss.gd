class_name DebugBoss
extends CharacterBody2D

const SPEED: float = 150.0

var lastDirection: Vector2 = Vector2(1, 0)


func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func look_toward(pos: Vector2) -> void:
	lastDirection = position.direction_to(pos)
	rotation = position.angle_to_point(pos)
	
func keep_distance_from(pos: Vector2, distance: float) -> void:
	look_toward(pos)
	var remainingDistanceFromPos = distance - position.distance_to(pos)
	print(remainingDistanceFromPos)
	if remainingDistanceFromPos <= 0: # if we are too far from pos, move toward it
		velocity = lastDirection * SPEED
	else: # move away
		velocity = -lastDirection * SPEED
