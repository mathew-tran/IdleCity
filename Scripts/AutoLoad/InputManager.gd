extends Node


var LastClickedObject = null
var LastHoveredObject = null

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
