extends "res://Scripts/Building/Building.gd"

var Content = preload("res://Prefab/UI/ResearchLabUI.tscn")

func Show():
	$ActiveParticle.emitting = true
	
func Hide():
	$ActiveParticle.emitting = false

func _on_Button_button_down():
	InputManager.Click(self)
	Helper.AddPopup("Research Lab", "Learn things!", Content)
