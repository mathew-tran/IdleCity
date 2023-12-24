extends "res://Scripts/Building/Building.gd"

var Content = preload("res://Prefab/UI/ResearchLabUI.tscn")

func OnLeftClick():
	InputManager.Click(self)
	Helper.AddPopup("Research Lab", "Learn things!", Content)
