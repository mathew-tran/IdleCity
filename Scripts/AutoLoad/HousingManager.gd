extends Node

func FindHouse(tenant):
	var housing = Finder.GetHousing()
	var closestHouse = null
	var closestPosition = 99999999999999999
	for house in housing:
		var deltaDistance = house.global_position.distance_to(tenant.global_position)
		if house.CanSubscribe():
			if deltaDistance < closestPosition:
				closestHouse = house

	if closestHouse == null:
		#print("Could not find house for: " + tenant.name)
		pass
	return closestHouse

