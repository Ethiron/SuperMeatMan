extends CanvasLayer

onready var colorRect = $Sprite
onready var animationPlayer = $AnimationPlayer
signal sceneChanged

func changeScene(path, delay):
	yield(get_tree().create_timer(delay), "timeout")
	animationPlayer.play("fade")
	yield(animationPlayer, "animation_finished")
	var sceneResult = get_tree().change_scene(path)
	if sceneResult == OK:
		animationPlayer.play_backwards("fade")
		emit_signal("sceneChanged")
