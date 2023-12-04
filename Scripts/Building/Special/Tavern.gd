extends "res://Scripts/Building/Building.gd"

var Content = preload("res://Prefab/UI/TavernUI.tscn")

func _ready():
	super()
	var _OnAvailable = TavernManager.connect("OnTavernAvailable", Callable(self, "Show"))
	var _OnUnavailable = TavernManager.connect("OnTavernUnavailable", Callable(self, "Hide"))
	Hide()

func Show():
	$ActiveParticle.emitting = true

func Hide():
	$ActiveParticle.emitting = false

func _on_Button_button_down():
	InputManager.Click(self)
	Helper.AddPopup("Tavern", "Recruit Peeple!", Content)
