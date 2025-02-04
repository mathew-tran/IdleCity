extends Label

var bHasProblem = false

signal OnInfoUpdate

func Show():
	OnInfoUpdate.emit()
