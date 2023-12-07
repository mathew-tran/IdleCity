extends Sprite2D

@export var BuildingLimit = 1
@export var bIsBlockingNavigation = false
var SubscribedPeeple = []
var SpawnArea = [Vector2.ZERO]

var PeepleInBuilding = []

@export var BuildingName = "ThisBuildingName"

@export var BuildingType : GameResources.BUILDING_TYPE

@export var RequirementType : Array[GameResources.RESOURCE_TYPE]
@export var RequirementAmount : Array[int]
@export var Description: String = "No description"

@export var HappinessAmount: int = 3

var bCanBeClicked = false

var bIsInMoveMode = false
var LastPosition = Vector2(0,0)

@export var BuildingPrefix = ""
var CachedSpawnArea = []

signal OnDestroyed

func _ready():
	SaveManager.AddToPersistGroup(self)
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", Callable(self, "HalfHourUpdate"))
	$Area2D.connect("mouse_entered", Callable(self, "OnMouseEntered"))
	$Area2D.connect("mouse_exited", Callable(self, "OnMouseExited"))
	name = BuildingPrefix

func Setup():
	if CachedSpawnArea.is_empty():
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
			area.append(Vector2i(x,y))
	return area

func GetCachedSpawnArea():
	return CachedSpawnArea

func HalfHourUpdate():
	for peeple in PeepleInBuilding:
		peeple.AddHappiness(HappinessAmount)

func _input(event):
	if bCanBeClicked and !bIsInMoveMode:
		if event.is_action_released("left_click"):
			OnLeftClick()
		if event.is_action_released("right_click"):
			OnRightClick()

func _process(delta):
	if bIsInMoveMode:
		var TargetPosition = get_global_mouse_position() - Vector2(16,16)
		var tile = Helper.GetTileInTilemap(TargetPosition)
		global_position = Finder.GetBuildTiles().map_to_local(tile)
		if Input.is_action_just_released("left_click"):
			if Helper.IsWaterTile(tile) == false:
				bIsInMoveMode = false
				UpdateLevelNavigation()
			else:
				Helper.AddPopupText(get_global_mouse_position(), "Cannot\nplace object!")
		if Input.is_action_just_released("right_click"):
			bIsInMoveMode = false
			global_position = LastPosition

func SetMoveMode(bIsMoving):
	await get_tree().create_timer(.1).timeout
	bIsInMoveMode = bIsMoving
	if bIsInMoveMode:
		LastPosition = global_position

func GetMoveMode():
	return bIsInMoveMode

func OnHover():
	modulate = "dedede"

func OnMouseEntered():
	bCanBeClicked = true

func OnMouseExited():
	bCanBeClicked = false

func OnLeftClick():
	pass

func OnRightClick():
	InputManager.ContextClick(self)

func OnExit():
	modulate = "ffffff"

func UpdateLevelNavigation():
	if bIsBlockingNavigation:
		for area in CachedSpawnArea:
			Helper.SetTile(area, GameResources.Tiles["Water"])


func Save():
	var tile = (CachedSpawnArea[0] - GetSpawnArea()[0])
	var dictionary = {
		"type" : "object",
		"filename" : get_scene_file_path(),
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
		PeepleInBuilding.remove_at(index)
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
			Helper.SetTile(area, GameResources.Tiles["Grass"])
