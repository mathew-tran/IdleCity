extends Node

var Tiles = {
	"Grass" : 0,
	"Water" : 1
}

var TileOffset = Vector2i(16, 16)

var COLOR_ACCEPT = "00bc68c9"
var COLOR_DECLINE = "ee3327ad"

enum BUILDING_TYPE {
	HOUSE,
	FACTORY,
	SPECIAL,
	DECOR
}
enum RESOURCE_TYPE {
	WOOD,
	STONE,
	COAL
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
