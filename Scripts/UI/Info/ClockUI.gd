extends Panel

func _ready():
	var _OnTimeUpdate = GameClock.connect("OnTimeUpdate", Callable(self, "UpdateUI"))
	UpdateUI()

func UpdateUI():
	$Label.text = GameClock.GetWeekday() + ", " + GameClock.GetMonth() + " " + str(GameClock.DayAmount) + ", " +  str(GameClock.YearAmount)
	#"Year " + str(GameClock.YearAmount) + ", Day " + str(GameClock.DayAmount) + "\n" + GameClock.GetTimeString()
	$Label.text += "\n" + GameClock.GetTimeString()
