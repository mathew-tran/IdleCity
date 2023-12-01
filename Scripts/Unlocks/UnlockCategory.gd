extends "res://Scripts/UI/Buttons/UnlockableButton.gd"

export (GameResources.CATEGORY_TYPE) var CategoryToUnlock

func RunUnlockFunction():
	ResearchManager.IncrementUnlockLevel(CategoryToUnlock)
	
func Save():
	return {
		"CategoryToUnlock" : CategoryToUnlock
	}

func Load(data):
	CategoryToUnlock = data["CategoryToUnlock"]
