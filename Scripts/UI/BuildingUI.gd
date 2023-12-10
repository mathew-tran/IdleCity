extends Panel

var ObjectToInteractWith = null

@onready var TenantBox = $RightSide/ScrollContainer/VBoxContainer
@onready var BuildingNameText = $LeftSide/VBoxContainer/BuildingName
@onready var BuildingHappinessText = $LeftSide/VBoxContainer/BuildingHappiness
@onready var BuildingDescriptionText = $LeftSide/VBoxContainer/BuildingDescription
@onready var BuildingPicture = $LeftSide/BuildingPicture

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	InputManager.connect("OnPlayContextClicked", Callable(self, "OnPlayContextClicked"))
	InputManager.connect("OnPeepleClicked", Callable(self, "OnPeepleClicked"))
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "PlayerModeChange"))

func OnPlayContextClicked(obj):
	visible = true
	ObjectToInteractWith = obj
	ObjectToInteractWith.modulate = Color(400, 400, 400, ObjectToInteractWith.modulate.a)
	BuildingNameText.text = obj.GetBuildingName()
	BuildingDescriptionText.text = obj.GetBuildingDescription()
	BuildingHappinessText.text = obj.GetHappinessString()
	BuildingPicture.texture = obj.GetBuildingTexture()

func PlayerModeChange(bIsBuildMode):
	if bIsBuildMode:
		visible = false


func OnPeepleClicked(obj):
	visible = false

func _on_exit_button_button_up():
	visible = false


func _on_visibility_changed():
	if visible == false:
		if ObjectToInteractWith:
			ObjectToInteractWith.modulate = Color.WHITE
		ObjectToInteractWith = null
		InputManager.LastContextObject = null

