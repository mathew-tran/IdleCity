extends Camera2D

var MoveSpeed = 200
var ZoomSpeed = 10
var MaxZoom = 1.6
var MinZoom = .5

@onready var Highlight = $Sprite2D

var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
var ClassInstance = null
var PurchaseButton = null

var bOnTile = true;
var previousMode = null


var CurrentPlayerMode = GameResources.UI_MODE.MENU


var FollowTarget = null

signal OnPlayerModeChange(bIsBuildMode)


func _ready():
	SetBuildingClass(BuildingClass, null)
	Helper.ShowBuildTileOutline(true)
	Finder.GetMenuUI().connect("tab_changed", Callable(self, "_on_TabContainer_tab_changed"))

func SetBuildingClass(newclass, purchaseButton):
	BuildingClass = newclass
	
	PurchaseButton = purchaseButton
	if ClassInstance:
		ClassInstance.queue_free()
	ClassInstance = BuildingClass.instantiate()	
	$Sprite2D/GhostImage.texture = ClassInstance.texture
	ClassInstance.Setup()
	
func _process(delta):

	if CurrentPlayerMode == GameResources.UI_MODE.BUILD:
		ProcessBuildMode(delta)
	else:
		ProcessMenuMode(delta)
		
	if Input.is_action_just_released("ScrollForward"):
		zoom -= Vector2(delta * ZoomSpeed, delta * ZoomSpeed)
		if zoom.x < MinZoom:
			zoom = Vector2(MinZoom, MinZoom)

	if Input.is_action_just_released("ScrollBackward"):
		zoom += Vector2(delta * ZoomSpeed, delta * ZoomSpeed)
		if zoom.x > MaxZoom:
			zoom = Vector2(MaxZoom, MaxZoom)
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
	var Tilemap = Finder.GetBuildTiles()
	var TargetPosition = get_global_mouse_position() - offset
			
	var tile = Tilemap.local_to_map(TargetPosition)
	
	if Input.is_action_just_pressed("left_click"):	
		if CanPurchase() and CanPlace():
			if Tilemap.get_cell(tile.x, tile.y) != Tilemap.INVALID_CELL:
				if Helper.IsValidSpawnLocation(ClassInstance.GetCachedSpawnArea(), tile):
					var newInstance = BuildingClass.instantiate()
					newInstance.Setup()
					Finder.GetBuildings().add_child(newInstance)				
					newInstance.position = Finder.GetBuildTiles().map_to_world(tile, true)
					newInstance.AdjustSpawnArea(tile)
					newInstance.UpdateLevelNavigation()				
					PurchaseButton.Purchase()
	
	if Input.is_action_just_pressed("right_click"):
		var building = Helper.GetBuildingOnTile(tile)
		if building:
			building.queue_free()
			

	if bOnTile and null == Helper.GetBuildingOnTile(tile) and Helper.IsValidSpawnLocation(ClassInstance.GetCachedSpawnArea(), tile) and CanPurchase():
		$Sprite2D/GhostImage.modulate = "5500ffc9"
	else:
		$Sprite2D/GhostImage.modulate = "55f70074"

func CanPlace():
	return get_local_mouse_position().x > -200
	
func ProcessMenuMode(_delta):
	if Helper.IsPopupVisible() == false:		
		GameClock.Resume()
	
	$Sprite2D.visible = false
	Helper.ShowBuildTileOutline(false)
	
	var Tilemap = Finder.GetBuildTiles()
	var TargetPosition = get_global_mouse_position() - offset
	var tile = Tilemap.local_to_map(TargetPosition)
	var building = Helper.GetBuildingOnTile(tile)
	
	InputManager.Hovered(building)

func MoveGhost(_delta):	
	var TargetPosition = get_global_mouse_position() - offset
	var tile = Finder.GetBuildTiles().local_to_map(TargetPosition)
	$Sprite2D.global_position = Finder.GetBuildTiles().map_to_world(tile, true)
	var Tilemap = Finder.GetBuildTiles()
	if Tilemap.get_cell(tile.x, tile.y) == Tilemap.INVALID_CELL:
		bOnTile = false
	else:
		bOnTile = true

func _on_TabContainer_tab_changed(tab):
	if tab == 1:
		ChangePlayerMode(GameResources.UI_MODE.BUILD)
	else:
		ChangePlayerMode(GameResources.UI_MODE.MENU)
