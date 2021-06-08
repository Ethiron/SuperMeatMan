extends RayCast2D

#export(bool) var isVertical = false
#export(Vector2) var laserDirection:Vector2 = Vector2(0,0)
var laserTarget:Vector2 = Vector2(0,0)
var drawOffset:Vector2 = Vector2(0,0)
#TIMER VARIABLES
export(float) var loopingTimerTime = 1.0
export(float) var disabledTimerTime = 1.5


signal PlayerCollision

func _ready():
	laserTarget = self.cast_to
	if cast_to.x < 0:
		drawOffset += Vector2(165, 0)
	if cast_to.x > 0:
		drawOffset += Vector2(-165, 0)
	if cast_to.y < 0:
		drawOffset += Vector2(0, 165)
	if cast_to.y > 0:
		drawOffset += Vector2(0, -165)

func _draw():
	if self.enabled:
		draw_line(global_position, self.global_position + laserTarget - drawOffset, Color.red, 2.0, true)

func _process(_delta):
	if self.enabled:
		laserTarget = self.cast_to
		if self.is_colliding():
			var coll = self.get_collider()
			print(coll.name)
			if (coll.name == "PlayerArea" or coll.name == "Player") and self.enabled:
				emit_signal("PlayerCollision")
				self.enabled = false
				$Timer.start(disabledTimerTime)
				return
			else:
				laserTarget = self.get_collision_point()
		
		if cast_to.x != 0 and cast_to.y != 0:
			pass
		elif cast_to.x > 0 or cast_to.x < 0:
			laserTarget = Vector2(laserTarget.x, 0)
		elif cast_to.y > 0 or cast_to.y < 0:
			laserTarget = Vector2(0, laserTarget.y)
		
		update()
	else:
		return
	
func _on_Timer_timeout():
	self.enabled = true
