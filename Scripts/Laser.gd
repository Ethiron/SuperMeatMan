extends Node2D

onready var laserRayCast = $RayCast2D
export(bool) var isVertical = false
var laserTarget:Vector2 = Vector2(0,0)
export(Vector2) var laserDirection:Vector2 = Vector2(0,0)
#TIMER VARIABLES
export(float) var loopingTimerTime = 1.0
export(float) var disabledTimerTime = 1.5


signal PlayerCollision

func _ready():
	laserRayCast.cast_to = laserDirection * Vector2(1000,1000)
	laserDirection = laserRayCast.cast_to.normalized()
	laserTarget = laserRayCast.cast_to

func _draw():
	if laserRayCast.enabled:
		if isVertical:
			draw_line(laserRayCast.position, laserTarget - Vector2(0,-165), Color.red, 2.0, true)
		else:
			draw_line(laserRayCast.position, laserTarget - Vector2(165,0), Color.red, 2.0, true)

func _process(_delta):
	if laserRayCast.enabled:
		laserTarget = laserRayCast.cast_to
		if laserRayCast.is_colliding():
			var coll = laserRayCast.get_collider()
			print(coll.name)
			if (coll.name == "PlayerArea" or coll.name == "Player") and laserRayCast.enabled:
				emit_signal("PlayerCollision")
				laserRayCast.enabled = false
				$Timer.start(disabledTimerTime)
				return
			else:
				laserTarget = laserRayCast.get_collision_point()
		
		if isVertical:
			laserTarget = Vector2(0, laserTarget.y)
		else:
			laserTarget = Vector2(laserTarget.x, 0)
		
		update()
	else:
		return
	
func _on_Timer_timeout():
	laserRayCast.enabled = true
