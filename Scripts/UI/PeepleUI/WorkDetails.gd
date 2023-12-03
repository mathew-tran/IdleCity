extends Control

@onready var WorkButton : Button = $Button
@onready var WorkLabel : Label = $WorkName

signal JobFollowClicked

func Update(trackedPeeple):
	if trackedPeeple:
		WorkButton.visible = trackedPeeple.GetWork() != null
		if trackedPeeple.GetWork():
			WorkLabel.text = trackedPeeple.GetWork().name
		else:
			WorkLabel.text = "Unemployed"


func _on_button_button_up():
	emit_signal("JobFollowClicked")

