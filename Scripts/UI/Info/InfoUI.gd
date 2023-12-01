extends Panel




# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_child(0).get_children():
		child.connect("OnInfoUpdate", self, "UpdateUI")

func UpdateUI():
	var bHasProblems = false
	for child in get_child(0).get_children():
		if child.bHasProblem:
			bHasProblems = true
	
	if bHasProblems:
		name = "Info (!)"
	else: 
		name = "Info"
