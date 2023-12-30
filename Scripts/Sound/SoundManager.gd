extends Node2D

var channels = []

# Channel 0 is music
# Channel 1 - 9 SFX

func _ready():
	for x in range(0, 10):
		var instance = AudioStreamPlayer2D.new()
		add_child(instance)
		channels.append(instance)
	pass

func PlaySound(sfx, channelIndex):
	channels[channelIndex].stream = sfx
	channels[channelIndex].play()

