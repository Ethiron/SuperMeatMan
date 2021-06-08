extends StaticBody2D

var activo = true

func _ready():
	$AnimationPlayer.play("aparecer")

func desaparecer():
	if activo == true:
		activo = false
		$AnimationPlayer.play("desaparecer")
		yield($AnimationPlayer, "animation_finished")
		$CollisionShape2D.queue_free()
		yield(get_tree().create_timer(5), "timeout")
		self.aparecer()
	else:
		return

func aparecer():
	$AnimationPlayer.play("aparecer")
	yield($AnimationPlayer, "animation_finished")
	createNewCollisionShape2D()
	activo = true

#CREAR NUEVO COLLISION SHAPE PARA COLISIONES POGEERS
func createNewCollisionShape2D(): 
	var newColShape = CollisionShape2D.new()
	newColShape.shape = RectangleShape2D.new()
	newColShape.shape.extents = Vector2(16,16)
	newColShape.position = Vector2(16,16)
	newColShape.name = "CollisionShape2D"
	self.add_child(newColShape)

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("player"):
		self.desaparecer()
