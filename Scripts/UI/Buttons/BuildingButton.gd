extends "res://Scripts/UI/Buttons/PurchaseButton.gd"

@export var BuildingClass = preload("res://Prefab/Buildings/Factories/Factory.tscn")
	
func _ready():
	super()
	Setup()
	
func Setup():
	var instance = BuildingClass.instantiate()
	$Name.text = instance.BuildingName
	$Description.text = DescriptionText
	instance.queue_free()
	
func _on_FactoryButton_pressed():
	Finder.GetPlayer().SetBuildingClass(BuildingClass, self)	
