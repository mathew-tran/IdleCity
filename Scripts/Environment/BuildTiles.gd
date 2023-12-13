extends TileMap

var AStarRef

func _ready():
	AStarRef = AStarGrid2D.new()
	AStarRef.region = get_used_rect()
	AStarRef.cell_size = Vector2(32, 32)
	AStarRef.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	AStarRef.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	AStarRef.diagonal_mode =AStarGrid2D.DIAGONAL_MODE_NEVER
	AStarRef.offset = position

	AStarRef.update()
	AStarRef.fill_weight_scale_region(AStarRef.region, GameResources.DefaultTravelWeight)


func GetAStarGrid():
	return AStarRef
