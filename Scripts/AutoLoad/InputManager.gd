extends Node


var LastClickedObject = null
var LastContextObject = null
var LastHoveredObject = null

signal OnBuildContextClicked(obj)
signal OnPlayContextClicked(obj)
signal OnPeepleClicked(obj)
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

func IsContextObject(obj):
	return obj == LastContextObject

func Internal_ContextClick(object):
	if LastContextObject:
		LastContextObject.modulate = Color.WHITE
	LastContextObject = object

func BuildContextClick(object):
	Internal_ContextClick(object)
	emit_signal("OnBuildContextClicked", object)

func PlayContextClick(object):
	Internal_ContextClick(object)
	emit_signal("OnPlayContextClicked", object)

func PeepleClick(object):
	emit_signal("OnPeepleClicked", object)

func CanInteractWithBuilding():
	return LastContextObject == null
