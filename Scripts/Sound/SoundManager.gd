extends Node2D

var channels = []

# Channel 0 is music
# Channel 1 - 9 SFX
var Music = ["res://Songs/IdleCity_Lake_4AM.mp3"]

var channelAmount = 10
func _ready():
	for x in range(0, channelAmount):
		var instance = AudioStreamPlayer2D.new()
		add_child(instance)
		channels.append(instance)
	channels[0].connect("finished", Callable(self, "OnMusicFinished"))
	_on_music_timer_timeout()

func PlaySound(sfx, channelIndex):
	channels[channelIndex].stream = sfx
	channels[channelIndex].play()

func EnableSoundFX(bEnabled):
	for x in range(1, channelAmount):
		channels[x].stream = null
		channels[x].stream_paused = bEnabled == false

func EnableMusic(bEnabled):
	channels[0].stream_paused = bEnabled == false

func EnableSound(bEnabled):
	EnableMusic(bEnabled)
	EnableSoundFX(bEnabled)

func _on_music_timer_timeout():
	PlaySound(load(Music[0]), 0)

func OnMusicFinished():
	$MusicTimer.start()
