extends Node

var Tiles = {
	"Grass" : 0,
	"Water" : 1
}

var TileOffset = Vector2i(16, 16)
var DefaultTravelWeight = 100.0

var COLOR_ACCEPT = "00bc68c9"
var COLOR_DECLINE = "ee3327ad"

enum BUILDING_TYPE {
	HOUSE,
	FACTORY,
	SPECIAL,
	DECOR,
	RECREATION,
	FOOD
}
enum RESOURCE_TYPE {
	WOOD,
	STONE,
	COAL,
	WHEAT
}

enum CATEGORY_TYPE {
	GENERAL,
	BOTANY
}

enum GRADE {
	A,
	B,
	C,
	D
}

func GetHappinessGrading(amount):
	if amount >= 86:
		return GRADE.A
	if amount >= 65:
		return GRADE.B
	if amount >= 35:
		return GRADE.C
	return GRADE.D

func GetProductivityGrading(peeple):
	var satiety = peeple.GetSatiety()
	var satietyWeighting = 40

	var satietyAmount = (satiety / 100.0) * satietyWeighting

	var happiness = peeple.GetHappiness()
	var happinessWeighting = 60

	var happinessAmount = (happiness / 100.0) * happinessWeighting

	return GetHappinessGrading(satietyAmount + happinessAmount)

enum UI_MODE {BUILD, PLAY}

func GetResName(resourceInt):
	return str(GameResources.RESOURCE_TYPE.keys()[resourceInt])


class Reward extends Resource:
	var ResourceType
	var Amount : int

	func GetRewardString() -> String:
		return str(Amount) + "x " + str(GameResources.RESOURCE_TYPE.keys()[ResourceType])

	func GetAmount() -> int:
		return Amount
