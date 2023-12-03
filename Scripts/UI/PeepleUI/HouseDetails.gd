extends Control

@onready var HouseButton : Button = $Button
@onready var HouseNameLabel : Label = $Label

signal HouseFollowClicked
var TrackedPeeple

func Update(trackedPeeple):
	if trackedPeeple:
		TrackedPeeple = trackedPeeple
		HouseButton.visible = trackedPeeple.GetHouse() != null
		if trackedPeeple.GetHouse():
			HouseNameLabel.text = trackedPeeple.GetHouse().name
		else:
			HouseNameLabel.text = "Homeless"

func _on_button_button_up():
	emit_signal("HouseFollowClicked")
