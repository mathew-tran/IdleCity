extends "res://Scripts/UI/Info/UIBase.gd"

func _ready():
	var _OnPeepleAdded = PeepleManager.connect("OnPeepleAdded", self, "Show")
	
func Show():
	text = str(Finder.GetPeeples().size()) + " Peeple"
	
