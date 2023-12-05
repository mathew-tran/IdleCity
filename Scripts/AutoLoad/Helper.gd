extends Node

var PopupTextClass = preload("res://Prefab/UI/PopupText.tscn")
func GetScriptName(object):
	var script = object.get_script().resource_path.split("/")
	var scriptName = script[len(script)-1].trim_suffix(".gd")
	return scriptName

func ShowBuildTileOutline(bEnable):
	var tileOutlines = get_tree().get_nodes_in_group("TileOutline")[0]
	if bEnable:
		tileOutlines.Show()
	else:
		tileOutlines.Hide()

func GetFormattedAmount(amount):
	var score = str(amount)
	if amount <= 1:
		return score
	var i : int = score.length() - 3
	while i > 0:
		score = score.insert(i, ",")
		i = i - 3
	return score

func AddPopup(contentTitle, contentDescription, newContent):
	Finder.GetContentPopup().ShowPopup(contentTitle, contentDescription, newContent)

func AddPopupText(position, textContent):
	var instance = PopupTextClass.instantiate()
	instance.SetText(textContent)
	instance.global_position = position
	get_tree().root.add_child(instance)

func IsPopupVisible():
	return Finder.GetContentPopup().visible

func AddDescriptionPopup(object):
	Finder.GetDescriptionUI().Show(object)

func ReparentNode(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func IsValidSpawnLocation(spawnArea, location):
	var buildings = Finder.GetBuildings()
	var takenSpots = []
	for building in buildings.get_children():
		for area in building.CachedSpawnArea:
			takenSpots.append(area)
	for area in spawnArea:
		if takenSpots.find(area + location) != -1:
			return false
	return true

func GetBuildingOnTile(tileLocation):
	tileLocation = Vector2i(tileLocation)
	var tiles = Finder.GetBuildings()
	for tile in tiles.get_children():
		for area in tile.CachedSpawnArea:
			if area == tileLocation:
				return tile
	return null

func GetTileInfo(tile):
	var Tilemap = Finder.GetBuildTiles()
	var tileData = Tilemap.get_cell_source_id(0, tile)
	if tileData == -1:
		return null
	return tileData

func SetTile(tile, tileTypeIndex):
	var Tilemap = Finder.GetBuildTiles()
	Tilemap.set_cell(0, tile, tileTypeIndex, Vector2i(0,0))



func GetTileInTilemap(globalPosition):
	var Tilemap = Finder.GetBuildTiles()
	var tile = Tilemap.local_to_map(globalPosition)
	return tile

func SendLogMessageToPlayer(message):
	var instance = load("res://Prefab/UI/MessageLog.tscn").instantiate()

	var MessageContainer = get_tree().get_nodes_in_group("MessageContainer")[0]
	MessageContainer.add_child(instance)
	instance.UpdateText(message)

func FocusCamera(object):
	Finder.GetPlayer().Focus(object)

func FollowCamera(object):
	Finder.GetPlayer().Follow(object)
