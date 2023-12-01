extends Sprite

var MorningColor = "0ac8bc00"
var DayColor = "28c8bc00"
var NightColor = "280037c8"
var MidnightColor = "47002eff"

func _ready():
	var _OnMorningTime = GameClock.connect("OnMorningTime", self, "OnMorningTime")
	var _OnDayTime = GameClock.connect("OnDayTime", self, "OnDayTime")
	var _OnNightTime = GameClock.connect("OnNightTime", self, "OnNightTime")
	var _OnMidnightTime = GameClock.connect("OnMidnightTime", self, "OnMidnightTime")
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
