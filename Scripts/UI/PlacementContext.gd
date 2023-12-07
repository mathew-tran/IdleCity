extends VBoxContainer

var ObjectToInteractWith = null

func _ready():
	visible = false
	InputManager.connect("OnContextClicked", Callable(self, "OnContextClicked"))
	InputManager.connect("OnClicked", Callable(self, "OnClicked"))

func OnContextClicked(obj):
	visible = true
	global_position = get_viewport().get_mouse_position()
	ObjectToInteractWith = obj
	$Label.text = "Object: " + ObjectToInteractWith.name

func OnClicked(obj):
	visible = false

func _on_cancel_button_button_up():
	visible = false


func _on_delete_button_button_up():
	ObjectToInteractWith.queue_free()
	visible = false

func _on_move_button_button_up():
	ObjectToInteractWith.SetMoveMode(true)
	visible = false
