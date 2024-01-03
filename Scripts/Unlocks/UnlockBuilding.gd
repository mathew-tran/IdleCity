extends "res://Scripts/UI/Buttons/UnlockableButton.gd"

@export var BuildingToUnlock = preload("res://Prefab/Buildings/Botany/Bush.tscn")

func RunUnlockFunction():
	Finder.GetBuildMenuUI().AddButton(BuildingToUnlock)

