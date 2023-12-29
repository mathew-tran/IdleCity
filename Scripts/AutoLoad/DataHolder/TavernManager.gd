extends "res://Scripts/AutoLoad/DataHolder/PersistentData.gd"

@export var RequirementType : Array[GameResources.RESOURCE_TYPE]
@export var RequirementAmount : Array[int]
var MaxAmount = 50
var CurrentAmount = 1
var bHasPurchased = true

signal OnTavernAvailable
signal OnTavernUnavailable

func _ready():
	RequirementType.append(0)
	RequirementAmount.append(1)
	var _OnDayUpdate = GameClock.connect("OnDayUpdate", Callable(self, "OnDayUpdate"))
	bHasPurchased = false

func OnDelete():
	RequirementAmount[0] = 1
	CurrentAmount = 1

func Save():
	var dict = {
		"type" : "auto",
		"script" : Helper.GetScriptName(self),
		"reqtype" : RequirementType[0],
		"reqamount" : RequirementAmount[0],
		"currentamount" : CurrentAmount
	}
	return dict

func Load(data):
	RequirementAmount[0] = data["reqamount"]
	RequirementType[0] = data["reqtype"]
	CurrentAmount = data["currentamount"]
	bHasPurchased = false


func GetRequirementAmount():
	return RequirementAmount

func GetRequirementType():
	return RequirementType

func OnDayUpdate():
	if CurrentAmount < MaxAmount:
		Increment()
		bHasPurchased = false
		emit_signal("OnTavernAvailable")


func SetFlag():
	bHasPurchased = true
	CurrentAmount += 1
	emit_signal("OnTavernUnavailable")

func GetFlag():
	return bHasPurchased

func Increment():
	RequirementAmount[0] += 10
	Helper.SendLogMessageToPlayer("Tavern is available to take new recruits!")

func CanGetMorePeeple():
	return CurrentAmount < MaxAmount

func GetMaxPeepleReachedMessage():
	return "You are at the max limit of peeple!"

func GetWaitForLaterMessage():
	return "Come back tommorow!"
