extends "res://Scripts/Building/Building.gd"

func _ready():
	super()
	$ActiveParticle.emitting = false
	
func OnActivated():
	$ActiveParticle.emitting = true

func OnDeactivated():
	$ActiveParticle.emitting = false
