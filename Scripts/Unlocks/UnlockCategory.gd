extends "res://Scripts/UI/Buttons/UnlockableButton.gd"

@export var CategoryToUnlock : GameResources.CATEGORY_TYPE

func RunUnlockFunction():
	ResearchManager.IncrementUnlockLevel(CategoryToUnlock)

