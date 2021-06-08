extends Node2D


func _ready():
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://World/Scenes/MainMenu.tscn")
