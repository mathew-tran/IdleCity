extends Node

func FindFood(employee):
	var foodHouses = Finder.GetFoodHouses()
	var closestFood = null
	var closestPosition = 99999999999999999
	for food in foodHouses:
		if food.CanSubscribe():
			var deltaDistance = food.global_position.distance_to(employee.global_position)
			if deltaDistance < closestPosition:
				closestFood = food

	return closestFood
