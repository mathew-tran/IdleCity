extends Panel


func _ready():
	GameClock.connect("OnTimeSpeedChange", Callable(self, "OnTimeSpeedChange"))

func OnTimeSpeedChange(eTimeSpeed):
	if eTimeSpeed == GameClock.TIME_SPEED.STOPPED:
		modulate = Color.RED
	elif eTimeSpeed == GameClock.TIME_SPEED.NORMAL:
		modulate = Color.WHITE
	elif eTimeSpeed == GameClock.TIME_SPEED.FAST:
		modulate = Color.GREEN_YELLOW
	elif eTimeSpeed == GameClock.TIME_SPEED.ULTRA_FAST:
		modulate = Color.GREEN
