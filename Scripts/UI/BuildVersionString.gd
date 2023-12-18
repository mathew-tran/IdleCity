extends Label


func _ready():
	text = "BUILD: " + str(BuildVersion.Version)
