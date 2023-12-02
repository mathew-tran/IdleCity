extends "res://Scripts/Building/Building.gd"

@export var ResourceType  : GameResources.RESOURCE_TYPE

func _ready():
	$ActiveParticle.emitting = false
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", Callable(self, "ProduceWork"))
	
	
func OnActivated():
	$ActiveParticle.emitting = true
	
func OnDeactivated():
	$ActiveParticle.emitting = false

func ProduceWork():
	if IsActive():
		await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
		var reward = GameResources.Reward.new()
		var bonus = 0
		for peeple in PeepleInBuilding:
			var awardAmount = 1
			var grade = GameResources.GetHappinessGrading(peeple.Happiness)
			if grade == GameResources.GRADE.A:
				awardAmount *= 3
			if grade == GameResources.GRADE.B:
				awardAmount *= 2
			if grade == GameResources.GRADE.D:
				awardAmount *= .5
			bonus += floor(awardAmount)
		reward.Amount = GetPeepleInBuildingAmount() + bonus
		reward.ResourceType = ResourceType
		InventoryManager.AddItem(reward)
		var textToSay = "+" + str(reward.Amount) + " " + GameResources.GetResName(reward.ResourceType)
		Helper.AddPopupText(position, textToSay)

