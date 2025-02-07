extends Panel

var ObjectToInteractWith = null


@onready var BuildingNameText = $LeftSide/VBoxContainer/BuildingName
@onready var BuildingHappinessText = $LeftSide/VBoxContainer/BuildingHappiness
@onready var BuildingDescriptionText = $LeftSide/VBoxContainer/BuildingDescription
@onready var BuildingPicture = $LeftSide/BuildingPicture

@onready var TenantUI = $TenantUI
@onready var TenantLabel = $TenantUI/TenantLabel
@onready var TenantBox = $TenantUI/ScrollContainer/VBoxContainer

@onready var TenantClassUI = preload("res://Prefab/UI/BuildingUI/BuildingTenantUI.tscn")

var FocusedBuilding = null
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	InputManager.connect("OnPlayContextClicked", Callable(self, "OnPlayContextClicked"))
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "PlayerModeChange"))

func OnPlayContextClicked(obj):
	visible = true
	if is_instance_valid(ObjectToInteractWith):
		if ObjectToInteractWith.is_connected("OnBuildingUpdate", Callable(self, "UpdateBuilding")):
			ObjectToInteractWith.disconnect("OnBuildingUpdate", Callable(self, "UpdateBuilding"))
	ObjectToInteractWith = obj
	ObjectToInteractWith.modulate = Color(2, 2, 2, ObjectToInteractWith.modulate.a)
	ObjectToInteractWith.connect("OnBuildingUpdate", Callable(self, "UpdateBuilding"))
	Finder.GetPlayer().GetSelectorBoarder().HoverSpriteObject(ObjectToInteractWith)
	UpdateBuilding()
		
func UpdateBuilding():
	if is_instance_valid(ObjectToInteractWith) == false:
		return

	BuildingNameText.text = ObjectToInteractWith.GetBuildingName()
	BuildingDescriptionText.text = ObjectToInteractWith.GetBuildingDescription()
	BuildingHappinessText.text = ObjectToInteractWith.GetHappinessString()
	BuildingHappinessText.visible = ObjectToInteractWith.GetHappiness() != 0
	BuildingPicture.texture = ObjectToInteractWith.GetBuildingTexture()

	if ObjectToInteractWith.GetMaxBuildingLimit() > 0:
		TenantUI.visible = true
		TenantLabel.text = "Users (" + str(ObjectToInteractWith.GetPeepleInBuildingAmount()) + "/" + str(ObjectToInteractWith.GetMaxBuildingLimit()) + ")"
		for tenant in TenantBox.get_children():
			tenant.queue_free()
		for tenant in ObjectToInteractWith.GetPeeple():
			var instance = TenantClassUI.instantiate()
			instance.Tenant = tenant
			TenantBox.add_child(instance)
	else:
		TenantUI.visible = false

func PlayerModeChange(bIsBuildMode):
	if bIsBuildMode:
		visible = false



func _on_exit_button_button_up():
	visible = false


func _on_visibility_changed():
	if visible == false:
		if ObjectToInteractWith:
			ObjectToInteractWith.modulate = Color.WHITE
			Finder.GetPlayer().GetSelectorBoarder().UnHover()
		ObjectToInteractWith = null
		InputManager.LastContextObject = null
