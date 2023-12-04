extends Label

func SetText(newText):
	text = newText

func _ready():
	$AnimationPlayer.play("GhostAnim")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
