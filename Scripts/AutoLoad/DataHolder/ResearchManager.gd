extends "res://Scripts/AutoLoad/DataHolder/PersistentData.gd"

var UnlockLevels = {}
var UnlockedButtons = {}

signal OnResearchGained

var LastTab = 0

var ResearchMenus = {
	"BOTANY" : "res://Prefab/Unlockables/Categories/BotanyUnlockables.tscn"
}

func _ready():
	pass
	
func OnLoadComplete():
	emit_signal("OnResearchGained")
	for button in UnlockedButtons:
		var unlocked = load(UnlockedButtons[button]["filename"]).instance()
		unlocked.Load((UnlockedButtons[button]["data"]))
		unlocked.RunUnlockFunction()
	
func OnDelete():
	UnlockLevels = {}
	UnlockedButtons = {}
	
func Save():
	var dict = {
	"type" : "auto",
	"script" : Helper.GetScriptName(self),
	"unlocklevels" : UnlockLevels,
	"unlockbuttons" : UnlockedButtons
	}
	return dict

func Load(data):
	UnlockLevels = data["unlocklevels"]
	UnlockedButtons = data["unlockbuttons"]
	
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
	if UnlockedButtons.has(button.name):
		return
		
	var time = OS.get_datetime()
	var display_string : String = "%02d/%02d/%02d %02d:%02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute, time.second];
	UnlockedButtons[button.name] = {
		"type" : "upgrade",
		"time" : display_string,
		"filename" : button.get_filename(),
		"data" : button.Save()
		}

func IsButtonUnlocked(button):
	return UnlockedButtons.has(button.name)

func GetButtonUnlockedTime(button):
	if IsButtonUnlocked(button):
		return UnlockedButtons[button.name]["time"]
	return "null"
	
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
