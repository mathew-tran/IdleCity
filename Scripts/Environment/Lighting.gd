extends Sprite2D

@export var MorningColor = Color("0ac8bc00")
@export var DayColor = Color("28c8bc00")
@export var NightColor = Color("28003782")
@export var MidnightColor = Color("47002eb9")

func _ready():
	var _onHourUpdate = GameClock.connect("OnHourUpdate", Callable(self, "OnHourUpdate"))

func GetColorForTime(currentTime, startTime, endTime, startColor, endColor):
	if currentTime < startTime or currentTime > endTime:
		return null
	var ratio = (float(currentTime) - startTime) / (endTime - startTime)
	return startColor.lerp(endColor, ratio)

func OnHourUpdate():
	var time = GameClock.TimeInHours
	var color = GetColorForTime(time, 0, 4, MidnightColor, MorningColor)
	if color == null:
		color = GetColorForTime(time, 4, 17, MorningColor, DayColor)
	if color == null:
		color = GetColorForTime(time, 17, 21, DayColor, NightColor)
	if color == null:
		color = GetColorForTime(time, 21, 23, NightColor, MidnightColor)
	if color == null:
		color = MidnightColor
	modulate = color


func OnMorningTime():
	modulate = MorningColor

func OnDayTime():
	modulate = DayColor

func OnNightTime():
	modulate = NightColor

func OnMidnightTime():
	modulate = MidnightColor
