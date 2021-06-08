extends Node2D

class WorldLevelManager:
	
	func changeToNextLevel(scene):
		EndLevelBlackScreen.changeScene(scene, 0.5)
	
	func resetCurrentLevel(scene):
		EndLevelBlackScreen.changeScene(scene, 0)
