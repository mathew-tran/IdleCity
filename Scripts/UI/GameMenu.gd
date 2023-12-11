extends CanvasLayer

@export var GameRunning = false
@onready var main_menu = $MainMenu
@onready var settings = $Settings
@onready var save_game = $MainMenu/VBoxContainer/SaveGame
@onready var load_game = $MainMenu/VBoxContainer/LoadGame
@onready var reset_data = $Settings/VBoxContainer/ResetData

func _ready():
	if FileAccess.file_exists(SaveManager.SaveFilePath):
		load_game.disabled = false
	if GameRunning:
		save_game.visible = true
		reset_data.disabled = false # Disabled if game not running. Requires refactoring to SaveManager.Reset()

func _on_new_game_pressed():
	StartGame(true)
	SaveManager.Reset()

func _on_save_game_pressed():
	SaveManager.Save()

func _on_load_game_pressed():
	StartGame(false)

func _on_settings_pressed():
	main_menu.hide()
	settings.show()

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	settings.hide()
	main_menu.show()

func _on_reset_data_pressed():
	SaveManager.Reset()
	GameClock.StartTime()
	GameClock.paused = false

func StartGame(newGame: bool):
	var scene = load("res://Scenes/Main.tscn")
	get_tree().change_scene_to_packed(scene)
	SaveManager.StartGame(newGame)
	GameClock.paused = false
	self.hide()
