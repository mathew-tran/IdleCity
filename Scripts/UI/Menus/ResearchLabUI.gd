extends Control

func _ready():
	var _OnResearchGained = ResearchManager.connect("OnResearchGained", self, "OnResearchGained")
	UpdateUI()
				
func OnResearchGained():
	var popup = Finder.GetContentPopup()
	yield(get_tree().create_timer(.2), "timeout")
	Finder.GetPlayer().PopMode()
	Helper.AddPopup(popup.GetTitle(), popup.GetDescription(), popup.GetContentClass())
	
	
func UpdateUI():
	if ResearchManager.IsCategoryUnlocked(GameResources.CATEGORY_TYPE.BOTANY):
		var instance = load(ResearchManager.ResearchMenus["BOTANY"]).instance()
		var bCanSpawn = true
		for child in $TabContainer.get_children():
			if child.name == instance.name:
				instance.queue_free()
				bCanSpawn = false
		if bCanSpawn:
			$TabContainer.add_child(instance)
	visible = false
	yield(get_tree().create_timer(.1), "timeout")
	$TabContainer.current_tab = ResearchManager.GetLastTab()
	visible = true
	for tab in $TabContainer.get_children():
		var bCanActivate = true
		var buttonContainer = tab.get_child(0).get_child(0)
		var purchaseButtons = buttonContainer.get_children()
		for button in purchaseButtons:
			if button.bHasBeenPurchased == false:
				if bCanActivate:
					bCanActivate = false
					button.visible = true
				else:
					button.visible = false
			if button.bHasBeenPurchased:
				bCanActivate = true
				button.visible = true
		for i in range(0, len(purchaseButtons)-1, 1):
			Helper.ReparentNode(purchaseButtons[i], buttonContainer)


func _on_TabContainer_tab_changed(tab):
	ResearchManager.CacheLastTab(tab)
