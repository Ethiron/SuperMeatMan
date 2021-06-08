tool
extends Node2D

export(bool) var isVertical = false setget updateIsVertical
export(bool) var startReverse = false
export(float) var distance = 150 setget updateTargetPos
export(float) var startingPercentage = 0
export(float) var speed = 100
var target
var distanceToTarget

func _ready():
	if (Engine.is_editor_hint()):
		return
	if isVertical:
		$Position2D.position = Vector2(0, distance)
		$SawWheel.position.y = startingPercentage * distance / 100
	else:
		$Position2D.position = Vector2(distance, 0)
		$SawWheel.position.x = startingPercentage * distance / 100
	target = $Position2D
	
	if startReverse:
		changeTarget()

func _process(delta):
	if (Engine.is_editor_hint()):
		return
	moveToTarget(delta)

func moveToTarget(argDelta):
	if (Engine.is_editor_hint()):
		return

	if isVertical:
		if $SawWheel.global_position.distance_to(target.global_position) > 5:
			$SawWheel.global_position += $SawWheel.global_position.direction_to(target.global_position) * speed * argDelta
		else:
			changeTarget()
	else:
		if $SawWheel.global_position.distance_to(target.global_position) > 5:
			$SawWheel.global_position += $SawWheel.global_position.direction_to(target.global_position) * speed * argDelta
		else:
			changeTarget()

func changeTarget():
	if target == $Position2D:
		target = $Position2D2
	else:
		target = $Position2D

func updateTargetPos(newVal):
	if (Engine.is_editor_hint()):
		if isVertical:
			$Position2D.position = Vector2(0, newVal)
		else:
			$Position2D.position = Vector2(newVal, 0)
	distance = newVal

func updateIsVertical(_val):
	isVertical = !isVertical
	updateTargetPos(distance)
