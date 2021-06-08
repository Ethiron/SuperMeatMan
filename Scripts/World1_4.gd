extends Node2D

var ZOOMING = false
const CURRENT_LEVEL = "res://World/Scenes/World1_4.tscn"
const NEXT_LEVEL = "res://World/Scenes/World1_5.tscn"
onready var camera = $Player/Camera2D
onready var player = $Player

var limits:Array = [-750, 2900, 875, -50]
signal PlayerOutOfBounds

func _ready():
	var dataToSave = {
		currentLevel = CURRENT_LEVEL
	}
	GameSavesScript.saveData(dataToSave)
	

func _process(_delta):
	if ZOOMING:
		camera.zoom.x = lerp(camera.zoom.x, 0.25, 0.05)
		camera.zoom.y = lerp(camera.zoom.x, 0.25, 0.05)
	if camera.zoom.x <= 0.26 or camera.zoom.y <= 0.26:
		ZOOMING = false
	
	if player.global_position.x > limits[1] or player.global_position.x < limits[3] or player.global_position.y < limits[0] or player.global_position.y > limits[2]:
		emit_signal("PlayerOutOfBounds")

func _on_Player_Player_On_Objective():
	ZOOMING = true
	EndLevelBlackScreen.changeScene(NEXT_LEVEL, 0)

func PlayerDed():
	EndLevelBlackScreen.changeScene(CURRENT_LEVEL, 0)


func _on_Player_PlayerDed():
	PlayerDed()
