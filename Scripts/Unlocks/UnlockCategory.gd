extends "res://Scripts/UI/Buttons/UnlockableButton.gd"

@export var CategoryToUnlock : GameResources.CATEGORY_TYPE

func RunUnlockFunction():
	ResearchManager.IncrementUnlockLevel(CategoryToUnlock)
	
func Save():
	return {
		"CategoryToUnlock" : CategoryToUnlock
	}

func Load(data):
	CategoryToUnlock = data["CategoryToUnlock"]
