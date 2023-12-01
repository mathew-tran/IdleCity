extends "res://Scripts/UI/Info/UIBase.gd"


func _ready():
	var _OnPeepleHouseUpdate = PeepleManager.connect("OnPeepleHouseUpdate", self, "Show")
	Show()
	
func Show():
	text = str(PeepleManager.GetUnHousedPeepleAmount()) + " Peeple missing a home"
	bHasProblem = PeepleManager.GetUnHousedPeepleAmount() > 0
	emit_signal("OnInfoUpdate")
	
