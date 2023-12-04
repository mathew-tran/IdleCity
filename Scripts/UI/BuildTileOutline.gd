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
	for tile in tiles.get_used_cells(0):
		set_cell(0, tile, 0)
