extends Camera2D

var MoveSpeed = 200
var ZoomSpeed = 7
var MaxZoom = 1.6
var MinZoom = .5
@onready var Highlight = $Sprite2D
@onready var GameMenu = $"../GameMenu"

var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var DefaultBuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var ClassInstance = null
var PurchaseButton = null

var previousMode = null


var CurrentPlayerMode = GameResources.UI_MODE.PLAY


var FollowTarget = null

signal OnPlayerModeChange(bIsBuildMode)

func _ready():
	GameMenu.hide()
	SetBuildingClass(BuildingClass, null)
	Helper.ShowBuildTileOutline(false)
	Finder.GetMenuUI().connect("tab_changed", Callable(self, "_on_TabContainer_tab_changed"))

func SetBuildingClass(newclass, purchaseButton):
	if ClassInstance:
		ClassInstance.queue_free()
	BuildingClass = newclass
	PurchaseButton = purchaseButton

	ClassInstance = BuildingClass.instantiate()
	$Sprite2D/GhostImage.texture = ClassInstance.texture
	$Sprite2D/GhostImage.visible = newclass != DefaultBuildingClass

func IsInBuildMode():
	return CurrentPlayerMode == GameResources.UI_MODE.BUILD

func _process(delta):
	if IsInBuildMode():
		ProcessBuildMode(delta)
	else:
		ProcessMenuMode(delta)

	if Input.is_action_just_pressed("escape"):
		if GameMenu.visible:
			GameClock.Resume()
			GameMenu.hide()
		else:
			GameClock.Pause()
			GameMenu.show()
		return

	if GameMenu.visible:
		return

	if Helper.IsMouseOnControl() == false:
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

	var adjustedDelta = 1.0 / 60.0

	if Input.is_action_pressed("ui_left"):
		position.x -= adjustedDelta * MoveSpeed
	if Input.is_action_pressed("ui_right"):
		position.x += adjustedDelta * MoveSpeed
	if Input.is_action_pressed("ui_up"):
		position.y -= adjustedDelta * MoveSpeed
	if Input.is_action_pressed("ui_down"):
		position.y += adjustedDelta * MoveSpeed


	if Input.is_action_just_pressed("middle_click"):
		$MiddleMouseImage.global_position = get_global_mouse_position()

	if Input.is_action_pressed("middle_click"):
		$MiddleMouseImage.visible = true
		if get_global_mouse_position().distance_to($MiddleMouseImage.global_position) > 10:
			var dir = (get_global_mouse_position() - $MiddleMouseImage.global_position).normalized()
			position += dir * adjustedDelta * MoveSpeed
			$MiddleMouseImage.look_at(get_global_mouse_position())
			$MiddleMouseImage.texture = preload("res://Art/UI/PointerIcon.png")
		else:
			$MiddleMouseImage.texture = preload("res://Art/UI/MoveIcon.png")
			$MiddleMouseImage.rotation_degrees = 0
	else:
		$MiddleMouseImage.visible = false

func ChangePlayerMode(newMode):
	CurrentPlayerMode = newMode
	OnPlayerModeChange.emit(CurrentPlayerMode == GameResources.UI_MODE.BUILD)


func CanPurchase():
	return PurchaseButton != null and PurchaseButton.CanAfford()

func PushMode(newMode):
	previousMode = CurrentPlayerMode
	ChangePlayerMode(newMode)

func PopMode():
	ChangePlayerMode(previousMode)

func Focus(object):
	position = object.position

func MoveToPosition(pos):
	global_position = pos

func Follow(object):
	FollowTarget = object

func GetFollowTarget():
	return FollowTarget

func ProcessBuildMode(delta):
	Helper.ShowBuildTileOutline(true)
	MoveGhost(delta)
	$Sprite2D.visible = true
	var TargetPosition =  Helper.GetCustomMousePosition()
	var tile = Helper.GetTileInTilemap(TargetPosition)
	var tileOffset = Vector2i(Finder.GetBuildTiles().map_to_local(tile))
	var potentialSpawnArea = ClassInstance.GetGlobalSpawnArea()

	for i in range(0, len(potentialSpawnArea)):
		potentialSpawnArea[i] += tileOffset

	if Helper.IsMouseOnControl():
		$Sprite2D.visible = false
		Follow(null)
		return
	if Input.is_action_just_pressed("left_click") and BuildingClass != DefaultBuildingClass:
		if CanPurchase():
			if Helper.IsPlaceable(potentialSpawnArea):
				var newInstance = BuildingClass.instantiate()
				Finder.GetBuildings().add_child(newInstance)
				newInstance.position = Finder.GetBuildTiles().map_to_local(tile)
				newInstance.UpdateLevelNavigation()
				PurchaseButton.Purchase()
			else:
				Helper.AddPopupText(get_global_mouse_position(), "Cannot\nplace object!")
		else:
			Helper.AddPopupText(get_global_mouse_position(), "Missing Resources!")
	if Input.is_action_just_pressed("right_click"):
		SetBuildingClass(DefaultBuildingClass, null)

	if Helper.IsPlaceable(potentialSpawnArea) and CanPurchase():
		$Sprite2D/GhostImage.modulate = GameResources.COLOR_ACCEPT
	else:
		$Sprite2D/GhostImage.modulate = GameResources.COLOR_DECLINE


func ProcessMenuMode(_delta):
	$Sprite2D.visible = false
	Helper.ShowBuildTileOutline(false)

	var Tilemap = Finder.GetBuildTiles()
	var TargetPosition = Helper.GetCustomMousePosition()
	var tile = Tilemap.local_to_map(TargetPosition)

func MoveGhost(_delta):
	var TargetPosition = Helper.GetCustomMousePosition()
	var tile = Helper.GetTileInTilemap(TargetPosition)
	$Sprite2D.global_position = Finder.GetBuildTiles().map_to_local(tile)


func _on_TabContainer_tab_changed(tab):
	if tab == 1:
		ChangePlayerMode(GameResources.UI_MODE.BUILD)
	else:
		ChangePlayerMode(GameResources.UI_MODE.PLAY)
