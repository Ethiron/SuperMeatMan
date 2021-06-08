tool
extends Position2D

export(float) var loopingTimerTime = 1.0
export(float) var disabledTimerTime = 1.5
export(Vector2) var castTo = Vector2(0,0) setget updateCastTo
onready var raycast = $RayCast2D
var laserTarget = Vector2.ZERO

func _ready():
	raycast.enabled = true

func _draw():
	if !Engine.is_editor_hint():
		draw_line(position, position + raycast.cast_to, Color.red, 2.0, true)
		draw_circle(position, 5, Color.green)

func _process(_delta):
	if !Engine.is_editor_hint():
		if raycast.is_colliding():
			var coll = raycast.get_collider()
			if coll.name == "Player" or coll.name == "PlayerArea":
				print("Player Collision")
			laserTarget = coll.global_position

func updateCastTo(newVal):
	castTo = newVal
	
	if Engine.is_editor_hint():
		$RayCast2D.cast_to = newVal
