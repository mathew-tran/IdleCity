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
	
func GenerateNavigationPath(currentPoint, targetPoint):
	var navigation = get_tree().get_nodes_in_group("Navigation")[0]
	return Navigation2DServer.map_get_path(navigation, currentPoint, targetPoint, false, 1)

func AddPopup(contentTitle, contentDescription, newContent):
	Finder.GetContentPopup().ShowPopup(contentTitle, contentDescription, newContent)

func AddPopupText(position, textContent):
	var instance = PopupTextClass.instance()
	instance.SetText(textContent)
	instance.rect_global_position = position
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
	var tiles = Finder.GetBuildings()
	var takenSpots = []
	for tile in tiles.get_children():
		for area in tile.CachedSpawnArea:
			takenSpots.append(area)			
	for area in spawnArea:
		if takenSpots.find(area + location) != -1:
			return false
	return true
	
func GetBuildingOnTile(tileLocation):
	var tiles = Finder.GetBuildings()
	for tile in tiles.get_children():
		for area in tile.CachedSpawnArea:
			if area == tileLocation:
				return tile
	return null

func SendLogMessageToPlayer(message):
	var instance = load("res://Prefab/UI/MessageLog.tscn").instance()
	
	var MessageContainer = get_tree().get_nodes_in_group("MessageContainer")[0]
	MessageContainer.add_child(instance)
	instance.UpdateText(message)

func FocusCamera(object):
	Finder.GetPlayer().Focus(object)
	
func FollowCamera(object):
	Finder.GetPlayer().Follow(object)
