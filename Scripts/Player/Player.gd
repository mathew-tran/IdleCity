extends Camera2D

var MoveSpeed = 200
var ZoomSpeed = 7
var MaxZoom = 1.6
var MinZoom = .5
@onready var Highlight = $Sprite2D
@onready var game_menu = $"../GameMenu"
@onready var canvas_layer = $"../CanvasLayer"

var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var DefaultBuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var ClassInstance = null
var PurchaseButton = null

var previousMode = null


var CurrentPlayerMode = GameResources.UI_MODE.PLAY


var FollowTarget = null

signal OnPlayerModeChange(bIsBuildMode)

func _ready():
	game_menu.GameRunning = true
	game_menu.hide()
	SetBuildingClass(BuildingClass, null)
	Helper.ShowBuildTileOutline(true)
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
	
	if Input.is_action_just_pressed("escape"):
		if !game_menu.visible:
			GameClock.StopTime()
			GameClock.paused = true
			game_menu.show()
		else:
			GameClock.StartTime()
			GameClock.paused = false
			game_menu.hide()

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
	var TargetPosition =  Helper.GetCustomMousePosition()
	var tile = Helper.GetTileInTilemap(TargetPosition)
	var tileOffset = Vector2i(Finder.GetBuildTiles().map_to_local(tile))
	var potentialSpawnArea = ClassInstance.GetGlobalSpawnArea()

	for i in range(0, len(potentialSpawnArea)):
		potentialSpawnArea[i] += tileOffset

	if Helper.IsMouseOnControl():
		return
	if Input.is_action_just_pressed("left_click") and BuildingClass != DefaultBuildingClass:
		if Helper.IsPlaceable(potentialSpawnArea):
			var newInstance = BuildingClass.instantiate()
			Finder.GetBuildings().add_child(newInstance)
			newInstance.position = Finder.GetBuildTiles().map_to_local(tile)
			newInstance.UpdateLevelNavigation()
			PurchaseButton.Purchase()
		else:
			Helper.AddPopupText(get_global_mouse_position(), "Cannot\nplace object!")
	if Input.is_action_just_pressed("right_click"):
		SetBuildingClass(DefaultBuildingClass, null)

	if Helper.IsPlaceable(potentialSpawnArea):
		$Sprite2D/GhostImage.modulate = GameResources.COLOR_ACCEPT
	else:
		$Sprite2D/GhostImage.modulate = GameResources.COLOR_DECLINE


func ProcessMenuMode(_delta):
	if Helper.IsPopupVisible() == false:
		GameClock.Resume()

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
