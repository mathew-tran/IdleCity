extends Control

var LastContentClass = null
func _ready():
	visible = false

func ShowPopup(contentTitle, contentDescription, content):
	GameClock.Pause()
	CleanPopup()
	$Panel/Title.text = contentTitle
	$Panel/Description.text = contentDescription
	LastContentClass = content
	var newChild = content.instantiate()
	$Panel/Content.add_child(newChild)
	visible = true
	Finder.GetPlayer().PushMode(GameResources.UI_MODE.PLAY)

func GetTitle():
	return $Panel/Title.text

func GetDescription():
	return $Panel/Description.text

func GetContentClass():
	return LastContentClass

func _process(_delta):
	if visible:
		if Input.is_action_just_released("escape"):
			ClosePopup()

func CleanPopup():
	for child in $Panel/Content.get_children():
		child.queue_free()

func ClosePopup():
	CleanPopup()
	Finder.GetPlayer().PopMode()
	visible = false
	GameClock.Resume()

func _on_ToolButton_button_up():
	ClosePopup()

func _on_Button_button_up():
	ClosePopup()
