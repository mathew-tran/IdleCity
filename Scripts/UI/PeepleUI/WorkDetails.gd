extends Control

@onready var WorkButton : Button = $Button
@onready var WorkLabel : Label = $WorkName

signal JobFollowClicked

func Update(trackedPeeple):
	if trackedPeeple:
		if trackedPeeple.GetWork():
			WorkLabel.text = trackedPeeple.GetWork().name
		else:
			WorkLabel.text = "Unemployed"

