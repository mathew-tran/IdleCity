extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func Show():
	visible = true
	
func Hide():
	visible = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Hide()
	var tiles = Finder.GetBuildTiles()
	for tile in tiles.get_used_cells():
		set_cell(tile.x, tile.y, 0)
