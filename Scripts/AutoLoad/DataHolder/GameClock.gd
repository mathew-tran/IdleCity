extends "res://Scripts/AutoLoad/DataHolder/PersistentData.gd"


var MinuteTimer = null
var MinuteIncreaseRate = 1
var MinuteDelayTime = .05

var TimeInMinutes = 55
var TimeInHours = 5

var DayAmount = 0
var YearAmount = 0

signal OnDayTime
signal OnNightTime
signal OnMidnightTime
signal OnMorningTime

signal OnTimeUpdate
signal OnHourUpdate
signal OnHalfHourUpdate
signal OnDayUpdate
signal OnYearUpdate

func _ready():
	MinuteTimer = Timer.new()
	MinuteTimer.wait_time = MinuteDelayTime
	MinuteTimer.one_shot = false
	add_child(MinuteTimer)
	MinuteTimer.connect("timeout", Callable(self, "OnTimerUpdate"))
	StartTime()

func OnLoadComplete():
	emit_signal("OnMidnightTime")

func OnDelete():
	TimeInHours = 5
	TimeInMinutes = 55
	DayAmount = 0
	YearAmount = 0

func Save():
	var dict = {
		"type" : "auto",
		"script" : Helper.GetScriptName(self),
		"minutes" : TimeInMinutes,
		"hours" : TimeInHours,
		"day" : DayAmount,
		"year" : YearAmount
	}
	return dict

func Load(data):
	if data.is_empty() == false:
		TimeInMinutes = data["minutes"]
		TimeInHours = data["hours"]
		DayAmount = data["day"]
		YearAmount = data["year"]

func StartTime():
	MinuteTimer.start()

func StopTime():
	MinuteTimer.stop()

func OnTimerUpdate():
	TimeInMinutes += MinuteIncreaseRate
	if TimeInMinutes >= 60:
		TimeInMinutes = 0
		TimeInHours += 1
		emit_signal("OnHourUpdate")
	if TimeInHours >= 24:
		TimeInHours = 0
		DayAmount += 1
		emit_signal("OnDayUpdate")
		if DayAmount >= 365:
			emit_signal("OnYearUpdate")
			YearAmount += 1
			DayAmount = 0

	if TimeInHours == 4 and TimeInMinutes == 0:
		emit_signal("OnMorningTime")
	if TimeInHours == 7 and TimeInMinutes == 0:
		emit_signal("OnDayTime")
		Helper.SendLogMessageToPlayer("Work time!")
	elif TimeInHours == 16 and TimeInMinutes == 0:
		emit_signal("OnNightTime")
		Helper.SendLogMessageToPlayer("After work time!")
	elif TimeInHours == 23 and TimeInMinutes == 0:
		emit_signal("OnMidnightTime")
	emit_signal("OnTimeUpdate")
	if TimeInMinutes == 0 or TimeInMinutes == 30:
		emit_signal("OnHalfHourUpdate")


func IsDayTime():
	return TimeInHours < 16


# TODO: MT: in the future. I think the work place should define the time to work, and the time for a break, as well as time for sleeping!
func IsWorkTime():
	return TimeInHours >= 6 and TimeInHours < 16

func IsStartingWorkDay():
	return TimeInHours == 6

func IsLunchTime():
	return TimeInHours == 12

func IsLunchFinishedTime():
	return TimeInHours == 14

func IsFinishingWorkDay():
	return TimeInHours == 20

func GetTimeString():
	var hours = str(TimeInHours).pad_zeros(2)
	var minutes = str(TimeInMinutes).pad_zeros(2)
	return str(hours) + ":" + str(minutes)

func Pause():
	get_tree().paused = true

func Resume():
	get_tree().paused = false

