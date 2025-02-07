extends Panel

var ObjectToInteractWith = null

@onready var ContextLabel = $PlacementContext/Label

func _ready():
	visible = false
	InputManager.connect("OnBuildContextClicked", Callable(self, "OnBuildContextClicked"))
	InputManager.connect("OnClicked", Callable(self, "OnClicked"))
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "OnPlayerModeChanged"))

func OnBuildContextClicked(obj):
	visible = true
	global_position = get_viewport().get_mouse_position() - Vector2(0, 64)
	ObjectToInteractWith = obj
	ContextLabel.text = "Object: " + ObjectToInteractWith.name
	ObjectToInteractWith.modulate = Color(2, 2, 2, ObjectToInteractWith.modulate.a)
	Finder.GetPlayer().GetSelectorBoarder().HoverSpriteObject(ObjectToInteractWith)

func _process(delta):
	if is_instance_valid(ObjectToInteractWith):
		global_position = Helper.WorldToScreen(ObjectToInteractWith.global_position) - Vector2(size.x/2, size.y)
					
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
		if event.is_action_pressed("right_click"):
			visible = false
		
	if Helper.IsMouseOnControl():
		visible = false
	

func _on_visibility_changed():
	if visible == false:
		if ObjectToInteractWith:
			ObjectToInteractWith.modulate = Color.WHITE
		Finder.GetPlayer().GetSelectorBoarder().UnHover()
		ObjectToInteractWith = null
		InputManager.LastContextObject = null
