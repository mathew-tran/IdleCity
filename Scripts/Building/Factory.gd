extends "res://Scripts/Building/Building.gd"

@export var ResourceType  : GameResources.RESOURCE_TYPE

func _ready():
	super()
	$ActiveParticle.emitting = false
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", Callable(self, "ProduceWork"))

	var unEmployedPeeple = PeepleManager.GetUnemployedPeeple()
	var tries = len(unEmployedPeeple)
	while tries > 0 and len(unEmployedPeeple) > 0:
		unEmployedPeeple[0].FindJob()
		tries -= 1


func ProduceWork():
	if IsActive():
		await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
		var reward = GameResources.Reward.new()
		var bonus = 0
		for peeple in PeepleInBuilding:
			var awardAmount = 1
			var grade = GameResources.GetProductivityGrading(peeple)
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

