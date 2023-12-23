extends "res://Scripts/Building/Building.gd"

@export var ResourceToConsume : GameResources.RESOURCE_TYPE
@export var ResourceToConsumeAmount = 2
@export var SatietyGained = 100
func _ready():
	super()
	$ActiveParticle.emitting = false
	var _OnHalfHourUpdate = GameClock.connect("OnHalfHourUpdate", Callable(self, "EatFood"))

func EatFood():
	if IsActive():
		if CanAffordFood():
			await get_tree().create_timer(randf_range(0.1, 0.5)).timeout

			var satietyPerPerson = float(float(SatietyGained) / float(len(PeepleInBuilding)))
			print(satietyPerPerson)
			for peeple in PeepleInBuilding:
				peeple.AddSatiety(satietyPerPerson)
				if peeple.IsFull():
					peeple.FindSomethingToDo()

			InventoryManager.RemoveItem(GameResources.GetResName(ResourceToConsume), ResourceToConsumeAmount)


func CanAffordFood():
	return InventoryManager.CheckIfItemExists(GameResources.GetResName(ResourceToConsume), ResourceToConsumeAmount)
