extends TileMap

func Show():
	visible = true

func Hide():
	visible = false

func _ready():
	Hide()
	var tiles = Finder.GetBuildTiles()
	for tile in tiles.get_used_cells(0):
		set_cell(0, tile, 0)
