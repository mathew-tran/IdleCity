extends Node

func FindJob(employee):
	var factories = Finder.GetFactories()
	var closestFactory = null
	var closestPosition = 99999999999999999
	for factory in factories:
		var deltaDistance = factory.global_position.distance_to(employee.global_position)
		if factory.CanSubscribe():
			if deltaDistance < closestPosition:
				closestFactory = factory

	return closestFactory
