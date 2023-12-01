extends Sprite


export var BuildingLimit = 1
export var bIsBlockingNavigation = false
var SubscribedPeeple = []
var SpawnArea = [Vector2.ZERO]

var PeepleInBuilding = []

export var BuildingName = "ThisBuildingName"

export (GameResources.BUILDING_TYPE) var BuildingType = GameResources.BUILDING_TYPE.FACTORY

export(Array, GameResources.RESOURCE_TYPE) var RequirementType
export(Array, int) var RequirementAmount
export(String) var Description = "No description"

export(int) var HappinessAmount = 3

export var bShowClickable = false

var CachedSpawnArea = []
signal OnDestroyed

func _ready():
	SaveManager.AddToPersistGroup(self)
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", self, "HalfHourUpdate")

func Setup():
	if CachedSpawnArea.empty():
		CachedSpawnArea = GetSpawnArea()

func AdjustSpawnArea(tileDisplacement):
	for area in range(0, len(CachedSpawnArea)):
		CachedSpawnArea[area].x += tileDisplacement.x
		CachedSpawnArea[area].y += tileDisplacement.y

func GetSpawnArea():
	#This only captures squares.
	var area = []
	var spawnWidth = int(texture.get_width() / 32.0)
	var spawnHeight = int(texture.get_height() / 32.0)
	for x in range(0, spawnWidth):
		for y in range(0, spawnHeight):
			area.append(Vector2(x,y))	
	return area
	
func GetCachedSpawnArea():
	return CachedSpawnArea
	
func HalfHourUpdate():
	for peeple in PeepleInBuilding:
		peeple.AddHappiness(HappinessAmount)
		
func OnHover():
	if bShowClickable:
		modulate = "dedede"
		pass

func OnClick():
	if bShowClickable:
		modulate = "7d7d7d"
		pass

func OnExit():
	if bShowClickable:
		modulate = "ffffff"
		pass
		
func UpdateLevelNavigation():
	if bIsBlockingNavigation:
		for area in CachedSpawnArea:
			Finder.GetBuildTiles().set_cell(area.x, area.y, 1)
		
	
func Save():
	var tile = (CachedSpawnArea[0] - GetSpawnArea()[0])
	var dictionary = {
		"type" : "object",
		"filename" : get_filename(),
		"pos_x" : position.x,
		"pos_y" : position.y,	
		"tile_x" : tile.x,
		"tile_y" : tile.y
		}
	return dictionary

func Load(dictData):
	position.x = dictData["pos_x"] 
	position.y = dictData["pos_y"]
	Setup()
	AdjustSpawnArea(Vector2(dictData["tile_x"], dictData["tile_y"]))
	
	Finder.GetBuildings().add_child(self)
	UpdateLevelNavigation()
	
func Enter(peeple):
	if PeepleInBuilding.has(peeple):
		return
	PeepleInBuilding.append(peeple)
	if PeepleInBuilding.size() == 1:
		OnActivated()
	
func Exit(peeple):
	if PeepleInBuilding.has(peeple):
		var index = PeepleInBuilding.find(peeple)
		PeepleInBuilding.remove(index)
	if PeepleInBuilding.size() == 0:
		OnDeactivated()

func IsActive():
	return GetPeepleInBuildingAmount() > 0
	
func GetPeepleInBuildingAmount():
	return PeepleInBuilding.size()
	
func CanSubscribe():
	return SubscribedPeeple.size() < BuildingLimit
	
func Subscribe(peeple):
	if CanSubscribe():
		SubscribedPeeple.append(peeple)
		return true
	else:
		return false

func OnActivated():
	pass

func OnDeactivated():
	pass

func _exit_tree():
	emit_signal("OnDestroyed")
	if bIsBlockingNavigation:
		for area in CachedSpawnArea:
			Finder.GetBuildTiles().set_cell(area.x, area.y, 0)
