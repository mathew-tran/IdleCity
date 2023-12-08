extends Node


var LastClickedObject = null
var LastContextObject = null
var LastHoveredObject = null

signal OnContextClicked(obj)
signal OnClicked(obj)

func Click(object):
	LastClickedObject = object
	emit_signal("OnClicked", LastClickedObject)

func GetLastClickedObject():
	return LastClickedObject

func Hovered(object):
	if is_instance_valid(LastHoveredObject):
		LastHoveredObject.OnExit()
	if object:
		LastHoveredObject = object
		LastHoveredObject.OnHover()

func ContextClick(object):
	if LastContextObject:
		LastContextObject.modulate = Color.WHITE
	LastContextObject = object
	emit_signal("OnContextClicked", object)
