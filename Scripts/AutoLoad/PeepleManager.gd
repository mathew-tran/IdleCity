extends Node

var AllPeeple = []
signal OnPeepleAdded

var UnHousedPeeple = []
signal OnPeepleHouseUpdate

var UnemployedPeeple = []
signal OnPeepleEmploymentUpdate

var RecPeeple =[]
signal OnRecPeepleUpdate

var FoodPeeple = []
signal OnFoodPeepleUpdate

var SpeedBuff = 1
var PeepleClass = preload("res://Prefab/Peeple/Peeple.tscn")

func AssignRandomName(peeple):
	var file = FileAccess.open("res://Content/names.txt", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	var peepleNames = data["Names"]
	file.close()
	peeple.SetPeepleName(peepleNames[randi() % len(peepleNames)])

func AssignRandomHobby(peeple):
	var file = FileAccess.open("res://Content/hobbies.txt", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	var activities = data["Activities"]
	file.close()
	peeple.SetPeepleHobby(activities[randi() % len(activities)])

func _ready():

	var _OnLoadComplete = SaveManager.connect("OnLoadComplete", Callable(self, "OnLoadComplete"))
	var _OnReload = SaveManager.connect("OnReload", Callable(self, "OnReload"))

func CheckMinPeepleSize():
	await get_tree().create_timer(0.2).timeout

	if Helper.IsInGame():
		if AllPeeple.size() == 0:
			var instance = PeepleClass.instantiate()
			add_child(instance)
			AddPeeple(instance)

func OnReload():
	var peepleGroup = Finder.GetPeepleGroup()
	if peepleGroup:
		for peeple in peepleGroup.get_children():
			peeple.queue_free()

	AllPeeple.clear()
	UnHousedPeeple.clear()
	UnemployedPeeple.clear()

	CheckMinPeepleSize()

func OnLoadComplete():
	CheckMinPeepleSize()

func AddPeeple(newPeeple):
	if AllPeeple.has(newPeeple) == false:
		AllPeeple.append(newPeeple)
		OnPeepleAdded.emit()
		Helper.ReparentNode(newPeeple, Finder.GetPeepleGroup())

func DeclareUnhoused(newPeeple):
	if UnHousedPeeple.has(newPeeple) == false:
		UnHousedPeeple.append(newPeeple)
		OnPeepleHouseUpdate.emit()
		var peepleString = newPeeple.GetPeepleName() + " has no house!"
		var data = {
			"message" : peepleString,
			"type" : "peeple-house",
			"peeple" : newPeeple,
			"unique" : true
		}
		Helper.Notify(data)
		newPeeple.BroadcaseHouseUpdate()

func GetUnHousedPeeple():
	return UnHousedPeeple

func DeclareHoused(currentPeeple):
	if UnHousedPeeple.has(currentPeeple):
		var index = UnHousedPeeple.find(currentPeeple)
		UnHousedPeeple.remove_at(index)
		OnPeepleHouseUpdate.emit()
	currentPeeple.BroadcaseHouseUpdate()

func GetUnHousedPeepleAmount():
	return UnHousedPeeple.size()

func DeclaredUnEmployed(newPeeple):
	if UnemployedPeeple.has(newPeeple) == false:
		UnemployedPeeple.append(newPeeple)
		OnPeepleEmploymentUpdate.emit()
		var peepleString = newPeeple.GetPeepleName() + " has no work!"
		var data = {
			"message" : peepleString,
			"type" : "peeple-job",
			"peeple" : newPeeple,
			"unique" : true
		}
		Helper.Notify(data)
	newPeeple.BroadcastJobUpdate()

func DeclareEmployed(currentPeeple):
	if UnemployedPeeple.has(currentPeeple):
		var index = UnemployedPeeple.find(currentPeeple)
		UnemployedPeeple.remove_at(index)
		OnPeepleEmploymentUpdate.emit()
	currentPeeple.BroadcastJobUpdate()

func DeclaredUnRecd(newPeeple):
	if RecPeeple.has(newPeeple) == false:
		RecPeeple.append(newPeeple)
		OnRecPeepleUpdate.emit()

func DeclaredRecd(currentPeeple):
	if RecPeeple.has(currentPeeple):
		var index = RecPeeple.find(currentPeeple)
		RecPeeple.remove_at(index)
		OnRecPeepleUpdate.emit()

func DeclaredHasFood(newPeeple):
	if FoodPeeple.has(newPeeple) == false:
		FoodPeeple.append(newPeeple)
		OnFoodPeepleUpdate.emit()

func DeclaredHasNoFood(currentPeeple):
	if FoodPeeple.has(currentPeeple):
		var index = FoodPeeple.find(currentPeeple)
		FoodPeeple.remove_at(index)
		OnFoodPeepleUpdate.emit()
		
func GetUnEmployedPeepleAmount():
	return UnemployedPeeple.size()

func GetUnemployedPeeple():
	return UnemployedPeeple

func IncrementSpeedBuff():
	SpeedBuff += 20

func GetSpeedBuff():
	return SpeedBuff
