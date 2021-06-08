extends Node2D

onready var masterVolume = $Control/MasterVolumeSlider
var savePath = "user://config.dat"

func _ready():
#	LOAD THE USER CONFIG AND ADJUST THE SETTINGS TO THAT
	Configuration.setEverythingToConfigSaved()
	masterVolume.value = Configuration.configData.master_volume



func _on_MasterVolumeSlider_value_changed(value):
	Configuration.configData.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_BackButton_pressed():
	if SaveCurrentConfig():
		print("config saved")
	else:
		print("config not saved")
	get_tree().change_scene("res://World/Scenes/MainMenu.tscn")

func SaveCurrentConfig():
	var file = File.new()
	var error = file.open(savePath, File.WRITE)
	if error == OK:
		file.store_var(Configuration.configData)
		file.close()
		return true
	else:
		print("error fatal, no se pudo crear/abrir el archivo")
		return false
