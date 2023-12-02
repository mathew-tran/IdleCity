extends "res://Scripts/UI/Buttons/PurchaseButton.gd"

var bHasBeenPurchased = false

@export var RequiredLevel = 0
@export (GameResources.CATEGORY_TYPE) var Category = GameResources.CATEGORY_TYPE.GENERAL

func PreSetup():
	Description = $Panel/HBoxContainer/VBoxContainer/Description
	Price = $Panel/HBoxContainer/VBoxContainer/Requirements
	$Panel/HBoxContainer/VBoxContainer/Title.text = DescriptionTitle
	$Panel/HBoxContainer/VBoxContainer/TimePurchased.text = ""
	bHasBeenPurchased = ResearchManager.IsButtonUnlocked(self)
	visible = false
func UpdateUI():
		
	super.UpdateUI()
	if bHasBeenPurchased:
		$Panel/HBoxContainer/Button.disabled = true
		$Panel.modulate = "464646"
		$Panel/HBoxContainer/Button.text = "UNLOCKED"
		var UnlockedTime = ResearchManager.GetButtonUnlockedTime(self)
		if  UnlockedTime != "null":
			$Panel/HBoxContainer/VBoxContainer/TimePurchased.text = UnlockedTime
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
	
func RunUnlockFunction():
	pass
