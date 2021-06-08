extends RayCast2D

func updateCastTo(newVal):
	cast_to = newVal

func _on_Laser_newCastTo(newVal):
	updateCastTo(newVal)
