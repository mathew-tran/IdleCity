extends Node

func GetGameMenu() -> GameMenu:
	return get_tree().get_nodes_in_group("GameMenu")[0]
	
func GetBuildMenuUI():
	return get_tree().get_nodes_in_group("BuildMenuUI")[0]

func GetPlayer() -> Player:
	return get_tree().get_nodes_in_group("Player")[0]

func GetBuildings():
	return get_tree().get_nodes_in_group("Buildings")[0]

func GetBuildTiles():
	return get_tree().get_nodes_in_group("BuildTiles")[0]

func GetFactories():
	return get_tree().get_nodes_in_group("Factory")

func GetRecHouses():
	return get_tree().get_nodes_in_group("Rec")

func GetFoodHouses():
	return get_tree().get_nodes_in_group("Food")

func GetHousing():
	return get_tree().get_nodes_in_group("House")

func GetPeeples():
	return get_tree().get_nodes_in_group("Peeple")

func GetPeepleGroup():
	var result = get_tree().get_nodes_in_group("PeepleGroup")
	if result:
		return result[0]
	return null

func GetCamera():
	return get_tree().get_nodes_in_group("Camera3D")[0]

func GetSound():
	return get_tree().get_nodes_in_group("SoundManager")[0]

func GetContentPopup():
	return get_tree().get_nodes_in_group("ContentPopup")[0]

func GetMenuUI():
	return get_tree().get_nodes_in_group("MenuUI")[0]

func GetLevelNavigator():
	return get_tree().get_nodes_in_group("LevelNavigator")[0]

func GetDescriptionUI():
	return get_tree().get_nodes_in_group("DescriptionUI")[0]

func GetNotifications():
	return get_tree().get_nodes_in_group("NotificationsManager")[0]

func GetSoundManager():
	return get_tree().get_nodes_in_group("SoundManager")[0]
