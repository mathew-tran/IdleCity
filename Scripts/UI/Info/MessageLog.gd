extends Label


func _ready():
	text = ""
	$AnimationPlayer.play("FadeOut")
	
func UpdateText(message):
	text = message
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
