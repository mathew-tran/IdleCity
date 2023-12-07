extends Camera2D

var MoveSpeed = 200
var ZoomSpeed = 10
var MaxZoom = 1.6
var MinZoom = .5
var Offset = Vector2(16, 16)
@onready var Highlight = $Sprite2D

var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var ClassInstance = null
var PurchaseButton = null

var previousMode = null


var CurrentPlayerMode = GameResources.UI_MODE.MENU


var FollowTarget = null

signal OnPlayerModeChange(bIsBuildMode)


func _ready():
	SetBuildingClass(BuildingClass, null)
	Helper.ShowBuildTileOutline(true)
	Finder.GetMenuUI().connect("tab_changed", Callable(self, "_on_TabContainer_tab_changed"))

	$Sprite2D/GhostImage.visible = false

func SetBuildingClass(newclass, purchaseButton):
	BuildingClass = newclass

	PurchaseButton = purchaseButton
	if ClassInstance:
		ClassInstance.queue_free()
	ClassInstance = BuildingClass.instantiate()
	$Sprite2D/GhostImage.texture = ClassInstance.texture
	$Sprite2D/GhostImage.visible = true
	ClassInstance.Setup()

func _process(delta):
	if CurrentPlayerMode == GameResources.UI_MODE.BUILD:
		ProcessBuildMode(delta)
	else:
		ProcessMenuMode(delta)

	if Input.is_action_just_released("ScrollForward"):
		zoom += Vector2(delta * ZoomSpeed, delta * ZoomSpeed)
		if zoom.x > MaxZoom:
			zoom = Vector2(MaxZoom, MaxZoom)

	if Input.is_action_just_released("ScrollBackward"):
		zoom -= Vector2(delta * ZoomSpeed, delta * ZoomSpeed)
		if zoom.x < MinZoom:
			zoom = Vector2(MinZoom, MinZoom)
	if FollowTarget:
		global_position = FollowTarget.position
		return

	if Input.is_action_pressed("ui_left"):
		position.x -= delta * MoveSpeed
	if Input.is_action_pressed("ui_right"):
		position.x += delta * MoveSpeed
	if Input.is_action_pressed("ui_up"):
		position.y -= delta * MoveSpeed
	if Input.is_action_pressed("ui_down"):
		position.y += delta * MoveSpeed

func ChangePlayerMode(newMode):
	CurrentPlayerMode = newMode
	emit_signal("OnPlayerModeChange", CurrentPlayerMode == GameResources.UI_MODE.BUILD)


func CanPurchase():
	return PurchaseButton != null and PurchaseButton.CanAfford()

func PushMode(newMode):
	previousMode = CurrentPlayerMode
	ChangePlayerMode(newMode)

func PopMode():
	ChangePlayerMode(previousMode)

func Focus(object):
	position = object.position

func Follow(object):
	FollowTarget = object

func ProcessBuildMode(delta):
	GameClock.Pause()
	Helper.ShowBuildTileOutline(true)
	MoveGhost(delta)
	$Sprite2D.visible = true
	var TargetPosition = get_global_mouse_position() - Offset

	var tile = Helper.GetTileInTilemap(TargetPosition)

	if Helper.IsMouseOnControl():
		return
	if Input.is_action_just_pressed("left_click"):
		if IsSpawnable(tile):
			var newInstance = BuildingClass.instantiate()
			newInstance.Setup()
			Finder.GetBuildings().add_child(newInstance)
			newInstance.position = Finder.GetBuildTiles().map_to_local(tile)
			newInstance.AdjustSpawnArea(tile)
			newInstance.UpdateLevelNavigation()
			PurchaseButton.Purchase()


	if IsSpawnable(tile):
		$Sprite2D/GhostImage.modulate = "00bc68c9"
	else:
		$Sprite2D/GhostImage.modulate = "ee3327ad"

func IsSpawnable(tile):
	return IsWaterTile(tile) == false and null == Helper.GetBuildingOnTile(tile) and Helper.IsValidSpawnLocation(ClassInstance.GetCachedSpawnArea(), tile) and CanPurchase()

func IsWaterTile(tile):
	var tileInfo = Helper.GetTileInfo(tile)
	if tileInfo != null:
		if tileInfo == GameResources.Tiles["Water"]:
			return true
	return false

func ProcessMenuMode(_delta):
	if Helper.IsPopupVisible() == false:
		GameClock.Resume()

	$Sprite2D.visible = false
	Helper.ShowBuildTileOutline(false)

	var Tilemap = Finder.GetBuildTiles()
	var TargetPosition = get_global_mouse_position() - Offset
	var tile = Tilemap.local_to_map(TargetPosition)
	var building = Helper.GetBuildingOnTile(tile)

	InputManager.Hovered(building)

func MoveGhost(_delta):
	var TargetPosition = get_global_mouse_position() - Offset
	var tile = Helper.GetTileInTilemap(TargetPosition)
	$Sprite2D.global_position = Finder.GetBuildTiles().map_to_local(tile)


func _on_TabContainer_tab_changed(tab):
	if tab == 1:
		ChangePlayerMode(GameResources.UI_MODE.BUILD)
	else:
		ChangePlayerMode(GameResources.UI_MODE.MENU)
