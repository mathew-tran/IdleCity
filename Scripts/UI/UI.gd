extends Panel

func _ready():
	var _OnInentoryUpdate = InventoryManager.connect("OnInventoryUpdate", self, "UpdateUI")

func UpdateUI():
	$Label.text = InventoryManager.GetItemsListToString()
