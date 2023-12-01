extends TabContainer


func _input(event):
	if event.is_action_pressed("F1"):
		current_tab = 0
	if event.is_action_pressed("F2"):
		current_tab = 1
	if event.is_action_pressed("F3"):
		current_tab = 2
		
