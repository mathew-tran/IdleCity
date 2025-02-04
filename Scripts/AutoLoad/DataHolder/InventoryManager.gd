extends "res://Scripts/AutoLoad/DataHolder/PersistentData.gd"

var Items = {}

signal OnInventoryUpdate

func _ready():
	pass

func OnLoadComplete():
	OnInventoryUpdate.emit()

func OnDelete():
	Items = {}
	OnInventoryUpdate.emit()

func Save():
	var dict = {
		"items" : Items,
		"type" : "auto",
		"script" : Helper.GetScriptName(self)
	}
	return dict

func Load(data):
	Items = data["items"]

func AddItem(Reward):
	var resourceType = GameResources.GetResName(Reward.ResourceType)
	var amount = Reward.GetAmount()
	if Items.has(resourceType):
		Items[resourceType] += amount
	else:
		Items[resourceType] = amount
	OnInventoryUpdate.emit()

func CheckIfItemExists(Item, Amount):
	if Items.has(Item):
		return Items[Item] >= Amount
	return false

func GetItemAmount(Item):
	if Items.has(Item):
		return Items[Item]
	return 0

func RemoveItem(Item, Amount):
	if CheckIfItemExists(Item, Amount):
		Items[Item] -= Amount
		OnInventoryUpdate.emit()
	else:
		print("Could not remove item: " + str(Item) + "(" + str(Amount) + ")" + " from inventory, did not have enough items!")

func PrintItems():
	for item in Items:
		print(str(item) + ": " + str(Items[item]))

func GetItemList():
	return Items

func GetItemsListToString():
	var itemString = ""
	for item in Items:
		itemString += str(item + ": " + str(Helper.GetFormattedAmount(Items[item])) + "\n")
	if itemString == "":
		itemString = "EMPTY"
	return itemString

func CanAfford(RequirementTypeList, RequirementAmountList):
	for resource in range(0, len(RequirementTypeList)):
		if false == InventoryManager.CheckIfItemExists(GameResources.GetResName(RequirementTypeList[resource]), RequirementAmountList[resource]):
			return false
	return true

func Purchase(RequirementTypeList, RequirementAmountList):
	if CanAfford(RequirementTypeList, RequirementAmountList):
		for resource in range(0, len(RequirementTypeList)):
			RemoveItem(GameResources.GetResName(RequirementTypeList[resource]), RequirementAmountList[resource])
