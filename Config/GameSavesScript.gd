extends Node

var savePath = "user://save.dat"

func saveData(argData) -> bool:
#	var data = {
#		currentLevel = "1",
#		currentRecord = "4:21"
#	}
	var file = File.new()
	var error = file.open(savePath, File.WRITE)
	if error == OK:
		file.store_var(argData)
		file.close()
		return true
	else:
		print("error fatal, no se pudo crear/abrir el archivo")
		return false
	
func loadData():
	var file = File.new()
	if file.file_exists(savePath):
		pass
	var error = file.open(savePath, File.READ)
	if error == OK:
		var gameData = file.get_var()
		file.close()
		return gameData
	else:
		return
