extends "res://Scripts/Building/Building.gd"

var Content = preload("res://Prefab/UI/TavernUI.tscn")

func _ready():
	super()
	var _OnAvailable = TavernManager.connect("OnTavernAvailable", Callable(self, "Show"))
	var _OnUnavailable = TavernManager.connect("OnTavernUnavailable", Callable(self, "Hide"))
	Hide()

func Show():
	$ActiveParticle.emitting = true
	var data = {
	"message" : "Recruitment available!",
	"unique" : true,
	"position" : global_position
	}
	Helper.Notify(data)


func Hide():
	$ActiveParticle.emitting = false

func OnLeftClick():
	InputManager.Click(self)
	Helper.AddPopup("Tavern", "Recruit Peeple!", Content)
