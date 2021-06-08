extends TileMap

export(PackedScene) var breakableStoneBlock
export(PackedScene) var wallBlock_Inca_Face_1

func _ready():
	changeTilesToNodes()

func changeTilesToNodes():
	var cells = self.get_used_cells()
	for cell in cells:
		var index = self.get_cell(cell.x, cell.y)
		match index:
			0:
				createIndexFromTilemap(cell, wallBlock_Inca_Face_1, get_parent())
			4:
				createIndexFromTilemap(cell, breakableStoneBlock, get_parent())

func createIndexFromTilemap(coord:Vector2, scene:PackedScene, parent:Node2D):
	set_cell(coord.x, coord.y, float(-1.0))
	var sceneBlock = scene.instance()
	sceneBlock.position = map_to_world(coord)
	parent.call_deferred("add_child", sceneBlock)
