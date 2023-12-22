extends Sprite2D

@export var BuildingLimit = 1
@export var bIsBlockingNavigation = false
@export var TravelCost = 0
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

var BlockedTiles = []

@export var BuildingPrefix = ""
var CachedSpawnArea = []

signal OnDestroyed
signal OnBuildingUpdate

var OldZIndex = 0


func _ready():
	OldZIndex = z_index
	SaveManager.AddToPersistGroup(self)
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", Callable(self, "HalfHourUpdate"))
	$Area2D.connect("mouse_entered", Callable(self, "OnMouseEntered"))
	$Area2D.connect("mouse_exited", Callable(self, "OnMouseExited"))
	name = BuildingPrefix
	LastPosition = global_position
	process_mode = Node.PROCESS_MODE_ALWAYS


func SetTravelCost(bSet = true):

	var newCost = GameResources.DefaultTravelWeight
	if bSet:
		newCost = TravelCost
	for area in CachedSpawnArea:
		var tile = Helper.GetTileInTilemap(area, Vector2(16, 16))
		Helper.SetTileOnGridWeight(tile, newCost)

func GetTileOffsets():
	var area = []
	var spawnWidth = int(texture.get_width() / 32.0)
	var spawnHeight = int(texture.get_height() / 32.0)
	for x in range(0, spawnWidth):
		for y in range(0, spawnHeight):
			area.append(Vector2i(x,y))
	return area

func GetGlobalSpawnArea():
	var globalTilePositions = []
	for tile in GetTileOffsets():
		globalTilePositions.append(tile * 32 + Vector2i(global_position))
	return globalTilePositions

func HalfHourUpdate():
	for peeple in PeepleInBuilding:
		peeple.AddHappiness(HappinessAmount)

func _input(event):

	if bCanBeClicked and !bIsInMoveMode and InputManager.IsContextObject(self) == false:
		if event.is_action_pressed("left_click") and Finder.GetPlayer().IsInBuildMode() == false:
			OnLeftClick()
		if event.is_action_pressed("right_click"):
			OnRightClick()

func IsInMoveMode():
	return bIsInMoveMode

func _process(delta):
	if bIsInMoveMode:
		z_index = 100
		var TargetPosition = Helper.GetCustomMousePosition()
		var tile = Helper.GetTileInTilemap(TargetPosition)
		global_position = Finder.GetBuildTiles().map_to_local(tile)
		var bIsPlaceable = Helper.IsPlaceable(GetGlobalSpawnArea())

		if bIsPlaceable:
			modulate =  GameResources.COLOR_ACCEPT
		else:
			modulate =  GameResources.COLOR_DECLINE

		if Input.is_action_just_released("left_click"):
			if bIsPlaceable:
				bIsInMoveMode = false
				UpdateLevelNavigation()
				modulate = Color.WHITE
				z_index = OldZIndex
			else:
				Helper.AddPopupText(get_global_mouse_position(), "Cannot\nplace object!")
		if Input.is_action_just_released("right_click"):
			bIsInMoveMode = false
			global_position = LastPosition
			modulate = Color.WHITE
			z_index = OldZIndex

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
	if Finder.GetPlayer().IsInBuildMode():
		InputManager.BuildContextClick(self)
	else:
		InputManager.PlayContextClick(self)

func OnExit():
	modulate = "ffffff"

func UpdateLevelNavigation():
	CachedSpawnArea = GetGlobalSpawnArea()
	if bIsBlockingNavigation:
		RemoveNavBlockers()
		AddNavBlockers()
	SetTravelCost(true)

func AddNavBlockers():
	for area in CachedSpawnArea:
		var tile = Helper.GetTileInTilemap(area, Vector2(16, 16))
		Helper.SetTileOnGridSolid(tile, true)
		BlockedTiles.append(tile)

func RemoveNavBlockers():
	for tile in BlockedTiles:
		Helper.SetTileOnGridSolid(tile, false)
	BlockedTiles.clear()

func Save():
	var dictionary = {
		"type" : "object",
		"filename" : get_scene_file_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		}
	return dictionary

func Load(dictData):
	position.x = dictData["pos_x"]
	position.y = dictData["pos_y"]

	Finder.GetBuildings().add_child(self)
	UpdateLevelNavigation()

func Enter(peeple):
	if PeepleInBuilding.has(peeple):
		emit_signal("OnBuildingUpdate")
		return
	PeepleInBuilding.append(peeple)
	if PeepleInBuilding.size() >= 1:
		OnActivated()
	emit_signal("OnBuildingUpdate")

func Exit(peeple):
	if PeepleInBuilding.has(peeple):
		var index = PeepleInBuilding.find(peeple)
		PeepleInBuilding.remove_at(index)
	if PeepleInBuilding.size() <= 0:
		OnDeactivated()
	emit_signal("OnBuildingUpdate")

func IsAPeepleInBuilding(peeple):
	return PeepleInBuilding.has(peeple)

func IsActive():
	return GetPeepleInBuildingAmount() > 0

func GetPeepleInBuildingAmount():
	return PeepleInBuilding.size()

func CanSubscribe():
	return SubscribedPeeple.size() < BuildingLimit

func GetMaxBuildingLimit():
	return BuildingLimit

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
	SetTravelCost(false)
	if bIsBlockingNavigation:
		RemoveNavBlockers()

func GetBuildingName():
	return BuildingName

func GetBuildingDescription():
	return Description

func GetHappinessString():
	return "Happiness: " + str(HappinessAmount)

func GetBuildingTexture():
	return texture

func GetHappiness():
	return HappinessAmount

func GetPeeple():
	return PeepleInBuilding
