extends "res://Scripts/Building/Building.gd"

func _ready():
	super()
	$ActiveParticle.emitting = false

	var unHousedPeeple = PeepleManager.GetUnHousedPeeple()
	var tries = len(unHousedPeeple)
	while tries > 0 and len(unHousedPeeple) > 0:
		if is_instance_valid(unHousedPeeple[0]):
			unHousedPeeple[0].FindHouse()
		tries -= 1

