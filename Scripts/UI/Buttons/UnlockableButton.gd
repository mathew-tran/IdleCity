extends "res://Scripts/UI/Buttons/PurchaseButton.gd"

var bHasBeenPurchased = false

@export var RequiredLevel = 0
@export var Category = GameResources.CATEGORY_TYPE.GENERAL
@export var UnlockID = "please_change"

func _ready():
	super()

func PreSetup():
	bHasBeenPurchased = ResearchManager.IsButtonUnlocked(self)
	Description = $Panel/HBoxContainer/VBoxContainer/Description
	Price = $Panel/HBoxContainer/VBoxContainer/Requirements
	$Panel/HBoxContainer/VBoxContainer/Title.text = DescriptionTitle
	visible = false
	UpdateUI()

	if bHasBeenPurchased:
		queue_free()

func UpdateUI():

	super.UpdateUI()
	if bHasBeenPurchased:
		$Panel/HBoxContainer/Button.disabled = true
		$Panel.modulate = "464646"
		$Panel/HBoxContainer/Button.text = "UNLOCKED"
	else:
		$Panel/HBoxContainer/Button.disabled = disabled

func _on_Button_button_down():
	if CanAfford():
		Purchase()
		bHasBeenPurchased = true
		UpdateUI()
		ResearchManager.IncrementUnlockLevel(Category)
		ResearchManager.CacheUnlockedButton(self)
		RunUnlockFunction()
		queue_free()

func RunUnlockFunction():
	pass

func GetUnlockID():
	return UnlockID
