extends Button

@export var RequirementType # (Array, GameResources.RESOURCE_TYPE)
@export var RequirementAmount # (Array, int)

@export var DescriptionTitle: String = "Title"
@export var DescriptionText: String = "No description"

var Description = null
var Price = null

func PreSetup():
	Description = get_node("Description")
	Price = get_node("Price")
	
func _ready():
	PreSetup()
	Description.text = DescriptionText
	
	UpdateUI()
	var _OnInventoryUpdate = InventoryManager.connect("OnInventoryUpdate", Callable(self, "UpdateUI"))
	

func UpdateUI():
	disabled = false == InventoryManager.CanAfford(RequirementType, RequirementAmount)
	Price.text = ""
	if len(RequirementAmount) == 0:
		Price.text = "FREE"
		return

	for resource in range(0, len(RequirementType)):
		var currentAmount = InventoryManager.GetItemAmount(GameResources.GetResName(RequirementType[resource]))
		Price.text += str(currentAmount) + "/" + str(RequirementAmount[resource]) + " " + GameResources.GetResName(RequirementType[resource]) + " | "
		
	Price.text = Price.text.strip_edges()
	Price.text = Price.text.trim_suffix("|")

func Purchase():
	InventoryManager.Purchase(RequirementType, RequirementAmount)
	ResearchManager.BroadcastOnResearchGained()

	
func CanAfford():
	return InventoryManager.CanAfford(RequirementType, RequirementAmount)
