extends Sprite2D

var MorningColor = "0ac8bc00"
var DayColor = "28c8bc00"
var NightColor = "28003782"
var MidnightColor = "47002eb9"

func _ready():
	var _OnMorningTime = GameClock.connect("OnMorningTime", Callable(self, "OnMorningTime"))
	var _OnDayTime = GameClock.connect("OnDayTime", Callable(self, "OnDayTime"))
	var _OnNightTime = GameClock.connect("OnNightTime", Callable(self, "OnNightTime"))
	var _OnMidnightTime = GameClock.connect("OnMidnightTime", Callable(self, "OnMidnightTime"))
	if GameClock.IsDayTime():
		OnDayTime()
	else:
		OnNightTime()
		
func OnMorningTime():
	modulate = MorningColor
	
func OnDayTime():
	modulate = DayColor
	
func OnNightTime():
	modulate = NightColor

func OnMidnightTime():
	modulate = MidnightColor
