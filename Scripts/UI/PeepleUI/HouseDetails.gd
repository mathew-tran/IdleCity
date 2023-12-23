extends Control

@onready var HouseButton : TextureButton = $Button
@onready var HouseNameLabel : Label = $Label

signal HouseFollowClicked
var TrackedPeeple

func Update(trackedPeeple):
	if trackedPeeple:
		TrackedPeeple = trackedPeeple
		if trackedPeeple.GetHouse():
			HouseNameLabel.text = trackedPeeple.GetHouse().name
		else:
			HouseNameLabel.text = "Homeless"
