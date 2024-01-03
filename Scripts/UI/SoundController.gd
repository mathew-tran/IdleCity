extends Button


var bIsEnabled = true


func _ready():
	$TextureRect.visible = false
func _on_button_up():
	bIsEnabled = !bIsEnabled
	$TextureRect.visible = bIsEnabled == false

	Finder.GetSoundManager().EnableSound(bIsEnabled)
