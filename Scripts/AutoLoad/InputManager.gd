extends Node


var LastClickedObject = null
var LastHoveredObject = null

signal OnContextClicked(obj)

func Click(object):
	LastClickedObject = object

func GetLastClickedObject():
	return LastClickedObject

func Hovered(object):
	if is_instance_valid(LastHoveredObject):
		LastHoveredObject.OnExit()
	if object:
		LastHoveredObject = object
		LastHoveredObject.OnHover()

func ContextClick(object):
	emit_signal("OnContextClicked", object)
