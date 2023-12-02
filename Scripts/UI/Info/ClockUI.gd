extends Panel

func _ready():
	var _OnTimeUpdate = GameClock.connect("OnTimeUpdate", Callable(self, "UpdateUI"))
	UpdateUI()

func UpdateUI():
	$Label.text = "Year " + str(GameClock.YearAmount) + ", Day " + str(GameClock.DayAmount) + "\n" + GameClock.GetTimeString()
