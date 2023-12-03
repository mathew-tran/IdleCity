extends Panel

func _ready():
	var _OnInentoryUpdate = InventoryManager.connect("OnInventoryUpdate", Callable(self, "UpdateUI"))

func UpdateUI():
	$Label.text = InventoryManager.GetItemsListToString()
