extends Button


signal OnNotificationClicked(obj)

var localData = {}
func _on_button_up():
	emit_signal("OnNotificationClicked", self)
	if localData.has("position"):
		Finder.GetPlayer().MoveToPosition(localData["position"])


func _on_exit_button_button_up():
	queue_free()

func SetData(notifyData):
	if notifyData.has("timer"):
		$Timer.wait_time = notifyData["timer"]
		$Timer.start()
	if notifyData.has("message"):
		$HBoxContainer/Label.text = notifyData["message"]
	localData = notifyData

func _on_timer_timeout():
	queue_free()

func IsDuplicate(newData):
	if localData.has("unique") and newData.has("unique"):
		if localData["unique"] and newData["unique"]:
			if localData["message"] == newData["message"]:
				return true
	return false
