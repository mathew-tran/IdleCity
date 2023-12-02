extends Node
	
func GetBuildMenuUI():
	return get_tree().get_nodes_in_group("BuildMenuUI")[0]
	
func GetPlayer():
	return get_tree().get_nodes_in_group("Player")[0]
	
func GetBuildings():
	return get_tree().get_nodes_in_group("Buildings")[0]

func GetBuildTiles():
	return get_tree().get_nodes_in_group("BuildTiles")[0]

func GetFactories():
	return get_tree().get_nodes_in_group("Factory")

func GetHousing():
	return get_tree().get_nodes_in_group("House")
	
func GetPeeples():
	return get_tree().get_nodes_in_group("Peeple")
	
func GetPeepleGroup():
	return get_tree().get_nodes_in_group("PeepleGroup")[0]
	
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
