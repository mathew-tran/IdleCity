extends HBoxContainer


func _ready():
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "PlayerModeChange"))
	_on_play_button_up()

func PlayerModeChange(bIsBuildMode):
	if bIsBuildMode:
		visible = false
	else:
		visible = true
		_on_pause_button_up()

func UpdateButtons(buttonToModulate):
	for child in get_children():
		child.modulate = Color.WHITE

	buttonToModulate.modulate = Color(10,10,10, 1)
	buttonToModulate.release_focus()

func _on_pause_button_up():
	GameClock.SetGameTime(0)
	UpdateButtons($Pause)

func _on_play_button_up():
	GameClock.SetGameTime(1)
	UpdateButtons($Play)

func _on_fast_forward_button_up():
	GameClock.SetGameTime(2)
	UpdateButtons($FastForward)

func _on_super_fast_forward_button_up():
	GameClock.SetGameTime(3)
	UpdateButtons($SuperFastForward)

func _input(event):
	if visible == false:
		return

	if event.is_action_pressed("Pause"):
		_on_pause_button_up()
	elif event.is_action_pressed("Play"):
		_on_play_button_up()
	elif event.is_action_pressed("FastForward"):
		_on_fast_forward_button_up()
	elif event.is_action_pressed("SuperFastForward"):
		_on_super_fast_forward_button_up()
