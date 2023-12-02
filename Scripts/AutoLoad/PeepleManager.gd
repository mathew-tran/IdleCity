extends Node

var AllPeeple = []
signal OnPeepleAdded

var UnHousedPeeple = []
signal OnPeepleHouseUpdate

var UnemployedPeeple = []
signal OnPeepleEmploymentUpdate

var SpeedBuff = 1
var PeepleClass = preload("res://Prefab/Peeple/Peeple.tscn")
var PeepleNames = []

func PopulateNames():
	var file = FileAccess.open("res://Content/names.txt", FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	PeepleNames = data["Names"]
	file.close()
	

func AssignRandomName(peeple):
	peeple.SetPeepleName(PeepleNames[randi() % len(PeepleNames)])
	
func _ready():
	
	var _OnLoadComplete = SaveManager.connect("OnLoadComplete", Callable(self, "OnLoadComplete"))
	var _OnReload = SaveManager.connect("OnReload", Callable(self, "OnReload"))
	PopulateNames()
	
func CheckMinPeepleSize():
	await get_tree().create_timer(0.2).timeout
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
		emit_signal("OnPeepleAdded")
		Helper.ReparentNode(newPeeple, Finder.GetPeepleGroup())

func DeclareUnhoused(newPeeple):
	if UnHousedPeeple.has(newPeeple) == false:
		UnHousedPeeple.append(newPeeple)
		emit_signal("OnPeepleHouseUpdate")

func DeclareHoused(currentPeeple):
	if UnHousedPeeple.has(currentPeeple):
		var index = UnHousedPeeple.find(currentPeeple)
		UnHousedPeeple.remove_at(index)
		emit_signal("OnPeepleHouseUpdate")

func GetUnHousedPeepleAmount():
	return UnHousedPeeple.size()

func DeclaredUnEmployed(newPeeple):
	if UnemployedPeeple.has(newPeeple) == false:
		UnemployedPeeple.append(newPeeple)
		emit_signal("OnPeepleEmploymentUpdate")
		
func DeclareEmployed(currentPeeple):
	if UnemployedPeeple.has(currentPeeple):
		var index = UnemployedPeeple.find(currentPeeple)
		UnemployedPeeple.remove_at(index)
		emit_signal("OnPeepleEmploymentUpdate")

func GetUnEmployedPeepleAmount():
	return UnemployedPeeple.size()
	
func IncrementSpeedBuff():
	SpeedBuff += 20

func GetSpeedBuff():
	return SpeedBuff
