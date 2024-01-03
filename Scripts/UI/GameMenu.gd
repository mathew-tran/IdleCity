extends CanvasLayer

@onready var MainMenu = $MainMenu
@onready var SettingsMenu = $Settings
@onready var NewGameButton = $MainMenu/VBoxContainer/NewGame
@onready var SaveGameButton = $MainMenu/VBoxContainer/SaveGame
@onready var LoadGameButton = $MainMenu/VBoxContainer/LoadGame
@onready var ResetDataButton = $Settings/VBoxContainer/ResetData
@onready var BackToMainMenuButton = $MainMenu/VBoxContainer/BackToMainMenu
@onready var ExitButton = $MainMenu/VBoxContainer/Exit

func _ready():
	if FileAccess.file_exists(SaveManager.SaveFilePath):
		LoadGameButton.disabled = false
	if Helper.IsInGame():
		NewGameButton.visible = false
		ExitButton.visible = false
	else:
		SaveGameButton.visible = false
		BackToMainMenuButton.visible = false

func _on_new_game_pressed():
	StartGame(true)
	SaveManager.Reset()

func _on_save_game_pressed():
	SaveManager.Save()

func _on_load_game_pressed():
	StartGame(false)

func _on_settings_pressed():
	MainMenu.hide()
	SettingsMenu.show()

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	SettingsMenu.hide()
	MainMenu.show()

func _on_reset_data_pressed():
	SaveManager.Reset()

func StartGame(newGame: bool):
	var scene = load(GameResources.GameScene)
	get_tree().change_scene_to_packed(scene)
	SaveManager.StartGame(newGame)
	GameClock.paused = false
	self.hide()


func _on_back_to_main_menu_pressed():
	var scene = load(GameResources.MenuScene)
	get_tree().change_scene_to_packed(scene)
