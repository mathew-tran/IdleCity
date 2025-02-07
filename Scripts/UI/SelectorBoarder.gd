extends Node2D

class_name SelectorBoarder

var FocusedObject : Sprite2D

func _ready():
	UnHover()
	
func HoverSpriteObject(obj):
	visible = true
	FocusedObject = obj	
	
func UnHover():
	visible = false
	FocusedObject = null
	
func _process(delta):
	if is_instance_valid(FocusedObject):
		global_position = FocusedObject.global_position
		$TR.position.x = FocusedObject.texture.get_width()
		$BR.position.x = FocusedObject.texture.get_width()
		$BR.position.y = FocusedObject.texture.get_height()
		$BL.position.y = FocusedObject.texture.get_height()
