extends Control

@onready var NotificationClass = preload("res://Prefab/UI/NotificationButton.tscn")

func _ready():
	for child in $VBoxContainer.get_children():
		child.queue_free()

func Notify(notifyData):
	var instance = NotificationClass.instantiate()
	$VBoxContainer.add_child(instance)
	instance.SetData(notifyData)
