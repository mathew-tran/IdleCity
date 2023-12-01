extends "res://Scripts/UI/Buttons/UnlockableButton.gd"

func RunUnlockFunction():
	PeepleManager.IncrementSpeedBuff()

func Save():
	return {}
	
func Load(data):
	return {}
