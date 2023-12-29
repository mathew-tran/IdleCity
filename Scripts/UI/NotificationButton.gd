extends Button


signal OnNotificationClicked(obj)

func _on_button_up():
	emit_signal("OnNotificationClicked", self)


func _on_exit_button_button_up():
	queue_free()

func SetData(notifyData):
	if notifyData.has("timer"):
		$Timer.wait_time = notifyData["timer"]
		$Timer.start()
	if notifyData.has("message"):
		$HBoxContainer/Label.text = notifyData["message"]


func _on_timer_timeout():
	queue_free()
