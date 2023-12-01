extends "res://Scripts/UI/Buttons/PurchaseButton.gd"


export var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
	
func _ready():
	Setup()
	
func Setup():
	var instance = BuildingClass.instance()
	$Name.text = instance.BuildingName
	instance.queue_free()
	
func _on_FactoryButton_pressed():
	Finder.GetPlayer().SetBuildingClass(BuildingClass, self)	
