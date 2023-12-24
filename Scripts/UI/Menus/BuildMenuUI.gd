extends Panel

@onready var Housing = $SubBuildMenu/Housing
@onready var Factories = $SubBuildMenu/Factories
@onready var Special = $SubBuildMenu/Special
@onready var Decor = $SubBuildMenu/Decor
@onready var Rec = $SubBuildMenu/Rec
@onready var Food = $SubBuildMenu/Food

var BuildingClass = preload("res://Prefab/Buttons/BuildingButton.tscn")

func _ready():
	AddButton(preload("res://Prefab/Buildings/SpecialBuildings/ResearchLab.tscn"))
	AddButton(preload("res://Prefab/Buildings/Factories/WoodFactory.tscn"))


func AddButton(buildingClass):
	var instance = buildingClass.instantiate()
	var buildingType = instance.BuildingType
	instance.queue_free()
	if buildingType == GameResources.BUILDING_TYPE.HOUSE:
		AddButtonToCategory(buildingClass, Housing)
	if buildingType == GameResources.BUILDING_TYPE.FACTORY:
		AddButtonToCategory(buildingClass, Factories)
	if buildingType == GameResources.BUILDING_TYPE.SPECIAL:
		AddButtonToCategory(buildingClass, Special)
	if buildingType == GameResources.BUILDING_TYPE.DECOR:
		AddButtonToCategory(buildingClass, Decor)
	if buildingType == GameResources.BUILDING_TYPE.RECREATION:
		AddButtonToCategory(buildingClass, Rec)
	if buildingType == GameResources.BUILDING_TYPE.FOOD:
		AddButtonToCategory(buildingClass, Food)

func AddButtonToCategory(housingClass, category):
	var bShouldCreate = true
	for child in category.get_child(0).get_children():
		if housingClass == child.BuildingClass:
			bShouldCreate = true
			break

	if bShouldCreate == false:
		return

	var housingClassInstance = housingClass.instantiate()

	var instance = BuildingClass.instantiate()
	instance.DescriptionText = housingClassInstance.Description
	instance.BuildingClass = housingClass
	instance.RequirementType = housingClassInstance.RequirementType
	instance.RequirementAmount = housingClassInstance.RequirementAmount
	instance.Setup()
	category.get_child(0).add_child(instance)
