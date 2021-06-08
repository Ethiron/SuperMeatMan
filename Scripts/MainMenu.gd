extends Node2D

const FirstLevel = "res://World/Scenes/World.tscn"

func _ready():
	Configuration.setEverythingToConfigSaved()

func _on_StartGameButton_pressed():
	get_tree().change_scene("res://World/Scenes/World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_ContinueButton_pressed():
	var gameData = GameSavesScript.loadData()
	get_tree().change_scene(gameData.currentLevel)


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://World/Scenes/OptionsMenu.tscn")
