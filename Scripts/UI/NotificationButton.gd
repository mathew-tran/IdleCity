extends Button


signal OnNotificationClicked(obj)

var localData = {}
func _on_button_up():
	emit_signal("OnNotificationClicked", self)
	if localData.has("position"):
		Finder.GetPlayer().MoveToPosition(localData["position"])
	if localData.has("peeple"):
		Finder.GetPlayer().Follow(localData["peeple"])
		Helper.AddDescriptionPopup(localData["peeple"])


func _on_exit_button_button_up():
	queue_free()

func SetData(notifyData):
	if notifyData.has("timer"):
		$Timer.wait_time = notifyData["timer"]
		$Timer.start()
	if notifyData.has("message"):
		$HBoxContainer/Label.text = notifyData["message"]
	if notifyData.has("type"):
		if notifyData["type"] == "peeple-job":
			notifyData["peeple"].connect("OnJobUpdate", Callable(self, "OnJobUpdate"))
		if notifyData["type"] == "peeple-house":
			notifyData["peeple"].connect("OnHouseUpdate", Callable(self, "OnHouseUpdate"))
		if notifyData["type"] == "tavern":
			TavernManager.connect("OnTavernUnavailable", Callable(self, "OnTavernUnavailable"))
	localData = notifyData

func OnJobUpdate(peeple):
	if peeple.CheckWorkPlace():
		queue_free()

func OnHouseUpdate(peeple):
	if peeple.CheckHouse():
		queue_free()

func OnTavernUnavailable():
	queue_free()

func _on_timer_timeout():
	queue_free()

func IsDuplicate(newData):
	if localData.has("unique") and newData.has("unique"):
		if localData["unique"] and newData["unique"]:
			if localData["message"] == newData["message"]:
				return true
	return false
