extends "res://Scripts/UI/Info/UIBase.gd"


func _ready():
	var _OnPeepleEmploymentUpdate = PeepleManager.connect("OnPeepleEmploymentUpdate", Callable(self, "Show"))
	Show()

func Show():
	text = str(PeepleManager.GetUnEmployedPeepleAmount()) + " Peeple have no job!"
	bHasProblem = PeepleManager.GetUnEmployedPeepleAmount() > 0
	emit_signal("OnInfoUpdate")
	if bHasProblem:
		var data = {
			"message" : "Unemployed Peeple",
			"type" : "peeple",
			"peepleGroup" : PeepleManager.GetUnemployedPeeple(),
			"unique" : false
		}
		Helper.Notify(data)
