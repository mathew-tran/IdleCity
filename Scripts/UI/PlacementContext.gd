extends Panel

var ObjectToInteractWith = null

@onready var ContextLabel = $PlacementContext/Label

func _ready():
	visible = false
	InputManager.connect("OnContextClicked", Callable(self, "OnContextClicked"))
	InputManager.connect("OnClicked", Callable(self, "OnClicked"))
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "OnPlayerModeChanged"))

func OnContextClicked(obj):
	visible = true
	global_position = get_viewport().get_mouse_position()
	ObjectToInteractWith = obj
	ContextLabel.text = "Object: " + ObjectToInteractWith.name
	ObjectToInteractWith.modulate = Color(400, 400, 400, ObjectToInteractWith.modulate.a)

func OnClicked(obj):
	visible = false

func OnPlayerModeChanged(bIsBuildMode):
	if bIsBuildMode == false:
		visible = false

func _on_cancel_button_button_up():
	visible = false


func _on_delete_button_button_up():
	ObjectToInteractWith.queue_free()
	visible = false

func _on_move_button_button_up():
	ObjectToInteractWith.SetMoveMode(true)
	visible = false

func _input(event):
	if visible:
		if event.is_action_pressed("escape"):
			visible = false
	if Helper.IsMouseOnControl():
		visible = false

func _on_visibility_changed():
	if visible == false:
		if ObjectToInteractWith:
			ObjectToInteractWith.modulate = Color.WHITE
		ObjectToInteractWith = null
		InputManager.LastContextObject = null
