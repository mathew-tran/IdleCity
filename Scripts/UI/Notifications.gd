extends Control

@onready var NotificationClass = preload("res://Prefab/UI/NotificationButton.tscn")

func _ready():
	for child in $VBoxContainer.get_children():
		child.queue_free()

#notifyData can take
# message (value in string)
# timer (value in seconds) - auto closes message after timer amount
# unique (value in bool) - determines if there should be more than one with the same message
# peepleGroup - (value in array of peeple), on click, will expand, and show you which peeple are afflicted, clicking onthem will make them focused / followed
# position - (value in vector2) - when clicked, brings player to error

func Notify(notifyData):
	for child in $VBoxContainer.get_children():
		if child.IsDuplicate(notifyData):
			return

	if is_instance_valid(NotificationClass) == false:
		return
	var instance = NotificationClass.instantiate()
	$VBoxContainer.add_child(instance)
	instance.SetData(notifyData)
