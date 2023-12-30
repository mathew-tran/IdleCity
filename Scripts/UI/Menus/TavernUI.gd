extends Control

var PeepleClass = preload("res://Prefab/Peeple/Peeple.tscn")

var RequirementType
var RequirementAmount

@onready var PurchaseButton = $VBoxContainer/Button
@onready var MessageText = $VBoxContainer/MessageText
@onready var RequirementText = $VBoxContainer/Requirements
@onready var RequirementTitle = $VBoxContainer/RequirementTitle

func _ready():
	RequirementType = TavernManager.GetRequirementType()
	RequirementAmount = TavernManager.GetRequirementAmount()
	PurchaseButton.disabled = !(InventoryManager.CanAfford(RequirementType, RequirementAmount) and TavernManager.CanGetMorePeeple())

	if PurchaseButton.disabled:
		if false == TavernManager.CanGetMorePeeple():
			MessageText.text = TavernManager.GetMaxPeepleReachedMessage()
		else:
			MessageText.text = "You do not meet the requirements!"
		MessageText.add_theme_color_override("font_color", Color.RED)
	elif TavernManager.GetFlag():
		PurchaseButton.disabled = true
		MessageText.text = TavernManager.GetWaitForLaterMessage()
		MessageText.add_theme_color_override("font_color", Color.RED)

	if  PurchaseButton.disabled == false:
		MessageText.text = "Recruit a Peeple"
	UpdateUI()

func UpdateUI():
	RequirementText.text = ""
	if TavernManager.CanGetMorePeeple():
		RequirementTitle.visible = true
		for resource in range(0, len(RequirementType)):
			var currentAmount = InventoryManager.GetItemAmount(GameResources.GetResName(RequirementType[resource]))
			RequirementText.text += str(currentAmount) + "/" + str(RequirementAmount[resource]) + " " + GameResources.GetResName(RequirementType[resource]) + "\n"
	else:
		RequirementTitle.visible = false

func _on_Button_button_down():
	if InventoryManager.CanAfford(RequirementType, RequirementAmount):
		InventoryManager.Purchase(RequirementType, RequirementAmount)
		UpdateUI()
		var instance = PeepleClass.instantiate()
		instance.position = InputManager.GetLastClickedObject().global_position
		Finder.GetPeepleGroup().add_child(instance)
		PurchaseButton.disabled = true
		Helper.PlaySound(load("res://SFX/You_Did_It.mp3"), 1)
		TavernManager.SetFlag()
		if TavernManager.CanGetMorePeeple():
			MessageText.text = "Thank you for recruiting! Come back later!"
		else:
			MessageText.text = TavernManager.GetMaxPeepleReachedMessage()
