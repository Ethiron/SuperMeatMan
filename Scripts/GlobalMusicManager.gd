extends Node2D

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
