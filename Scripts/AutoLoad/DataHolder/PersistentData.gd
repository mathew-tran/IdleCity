extends Node

func _enter_tree():
		var _OnLoadAuto = SaveManager.connect("OnLoadAuto", self, "OnLoadAuto")
	
		var _OnLoadComplete = SaveManager.connect("OnLoadComplete", self, "OnLoadComplete")
		var _OnDelete = SaveManager.connect("OnDelete", self, "OnDelete")

		SaveManager.AddToPersistGroup(self)
	
func OnLoadAuto(scriptName, data):
	if Helper.GetScriptName(self) == scriptName:
		Load(data)

func Load(data):
	pass
	
func OnLoadComplete():
	pass
	
func OnDelete():
	pass

