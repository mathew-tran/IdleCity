extends "res://Scripts/Building/Building.gd"

func _ready():
	$ActiveParticle.emitting = false
	
func OnActivated():
	$ActiveParticle.emitting = true

func OnDeactivated():
	$ActiveParticle.emitting = false
