extends Node

var SaveFilePath = "user://savegame.save"

var PersistTag = "Persist"

signal OnSave
signal OnLoad
signal OnDelete
signal OnReload
signal OnLoadAuto(name, data)
signal OnLoadComplete

func AddToPersistGroup(node):
	node.add_to_group(PersistTag)

func StartGame(newGame: bool):
	GameClock.Start()
	var _OnDayUpdate = GameClock.connect("OnMorningTime", Callable(self, "Save"))
	await get_tree().create_timer(0.2).timeout
	if !newGame:
		Load()

func Save():
	var saveGame = FileAccess.open(SaveFilePath, FileAccess.WRITE)
	var saveNodes = get_tree().get_nodes_in_group(PersistTag)
	for savedNode in saveNodes:
		var nodeData = savedNode.call("Save")
		saveGame.store_line(JSON.stringify(nodeData))
	saveGame.close()
	emit_signal("OnSave")
	Helper.SendLogMessageToPlayer("Game Saved.")

func Load():
	emit_signal("OnLoad")
	if FileAccess.file_exists(SaveFilePath):
		var saveGame = FileAccess.open(SaveFilePath, FileAccess.READ)
		while not saveGame.eof_reached():
			var lineData = saveGame.get_line()
			if lineData.is_empty():
				continue
			var test_json_conv = JSON.new()
			test_json_conv.parse(lineData)
			var currentLine = test_json_conv.get_data()
			if currentLine:
				if currentLine["type"] == "object":
					var newObject = load(currentLine["filename"]).instantiate()
					newObject.Load(currentLine)
				elif currentLine["type"] == "auto":
					# Use expressions: https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html
					emit_signal("OnLoadAuto", currentLine["script"], currentLine)
		saveGame.close()

	emit_signal("OnLoadComplete")

func Reset():
	set_process(false)
	var dir = DirAccess.open(SaveFilePath)
	if  dir:
		dir.remove(SaveFilePath)
	emit_signal("OnDelete")
	var _sceneReload = get_tree().reload_current_scene()
	emit_signal("OnReload")
	set_process(true)

