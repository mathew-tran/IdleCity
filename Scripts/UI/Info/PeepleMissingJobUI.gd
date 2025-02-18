extends "res://Scripts/UI/Info/UIBase.gd"


func _ready():
	var _OnPeepleEmploymentUpdate = PeepleManager.connect("OnPeepleEmploymentUpdate", Callable(self, "Show"))
	Show()

func Show():
	text = str(PeepleManager.GetUnEmployedPeepleAmount()) + " Peeple have no job!"
	bHasProblem = PeepleManager.GetUnEmployedPeepleAmount() > 0
	OnInfoUpdate.emit()
