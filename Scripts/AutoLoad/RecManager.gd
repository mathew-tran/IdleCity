extends Node

func FindRec(employee):
	var recHouses = Finder.GetRecHouses()
	var closestRec = null
	var closestPosition = 99999999999999999
	for rec in recHouses:
		if rec.CanSubscribe():
			var deltaDistance = rec.global_position.distance_to(employee.global_position)
			if  deltaDistance < 400:
				if deltaDistance < closestPosition:
					closestRec = rec

	return closestRec
