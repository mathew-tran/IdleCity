extends "res://Scripts/AutoLoad/DataHolder/PersistentData.gd"

var UnlockLevels = {}
var Unlocks = {}

signal OnResearchGained

var LastTab = 0

var ResearchMenus = {
	"GENERAL" : "res://Prefab/Unlockables/Categories/GeneralUnlockables.tscn",
	"BOTANY" : "res://Prefab/Unlockables/Categories/BotanyUnlockables.tscn"
}

func OnLoadComplete():
	emit_signal("OnResearchGained")
	for menu in ResearchMenus.keys():
		var instance = load(ResearchMenus[menu]).instantiate()
		for button in instance.GetButtons():
			if button.GetUnlockID() in Unlocks:
				button.RunUnlockFunction()
		instance.queue_free()


func OnDelete():
	UnlockLevels = {}
	Unlocks = {}

func Save():
	var dict = {
	"type" : "auto",
	"script" : Helper.GetScriptName(self),
	"unlocklevels" : UnlockLevels,
	"unlocks" : Unlocks
	}
	return dict

func Load(data):
	UnlockLevels = data["unlocklevels"]
	Unlocks = data["unlocks"]

func GetUnlockLevel(category):
	if UnlockLevels.has(str(category)):
		return UnlockLevels[str(category)]
	return 0

func IncrementUnlockLevel(category):
	if UnlockLevels.has(str(category)):
		UnlockLevels[str(category)] += 1
	else:
		UnlockLevels[str(category)] = 1


func CacheUnlockedButton(button):
	if IsButtonUnlocked(button):
		return

	Unlocks[button.GetUnlockID()] = true

func IsButtonUnlocked(button):
	return Unlocks.has(button.GetUnlockID())

func IsCategoryUnlocked(category):
	if UnlockLevels.has(str(category)):
		return UnlockLevels[str(category)] > 0
	return false

func BroadcastOnResearchGained():
	emit_signal("OnResearchGained")

func CacheLastTab(tabIndex):
	LastTab = tabIndex

func GetLastTab():
	return LastTab
