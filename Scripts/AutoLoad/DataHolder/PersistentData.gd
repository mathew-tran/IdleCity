extends Node

func _enter_tree():
		var _OnLoadAuto = SaveManager.connect("OnLoadAuto", Callable(self, "OnLoadAuto"))

		var _OnLoadComplete = SaveManager.connect("OnLoadComplete", Callable(self, "OnLoadComplete"))
		var _OnDelete = SaveManager.connect("OnDelete", Callable(self, "OnDelete"))

		SaveManager.AddToPersistGroup(self)

func OnLoadAuto(scriptName, data):
	if Helper.GetScriptName(self) == scriptName:
		Load(data)

func Load(_data):
	pass

func OnLoadComplete():
	pass

func OnDelete():
	pass

