extends Node

var music_enabled : bool
var fx_enabled : bool
var music_volume:float
var fx_volume:float

var fullscreen : bool

var savePath = "user://config.dat"
var configData = {
	master_volume = 0,
	music_volume = 0,
	sfx_volume = 0
}

func setEverythingToConfigSaved():
	var file = File.new()
	if !file.file_exists(savePath):
		return
	var error = file.open(savePath, File.READ)
	if error == OK:
		var loadedConfig = file.get_var()
		file.close()
		
		#Master Volume
		configData.master_volume = loadedConfig.master_volume
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), configData.master_volume)
		
	else:
		return
	
	
	#Music Volume
	#SFX Volume
