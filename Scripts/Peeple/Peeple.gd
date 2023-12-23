extends Sprite2D

var TargetPosition = Vector2()
var StartPosition = Vector2()
var bHasNewTarget = false
var WorkPlace = null
var House = null
var RecPlace = null

var CurrentPath = []
var CurrentPathIndex = 0

@export var Speed = 125.0
var SpeedBonus = 0

var Happiness = 50

signal OnHappinessUpdate
signal OnJobUpdate
signal OnHouseUpdate
signal OnRecUpdate


var colors = [Color(1.0, 1.0, 1.0, 1.0),
			Color(.20, 1.0, 0.2, 1.0),
			Color(0.5, 0.6, 1.0, 1.0),
			Color(1.0, 0.0, 0.0, 1.0),
			Color(0.0, 1.0, 0.0, 1.0),
			Color(0.0, 0.0, 1.0, 1.0)
		]

var bProcessLostSubscription = false
var PeepleName = ""
var PeepleHobby = ""
var bHasBeenSet = false
var SpeedDelta : float

enum AI_STATES {
	WANDER,
	GOWORK,
	FINDWORK,
	GOREC,
	FINDREC,
	GOHOME,
	FINDHOME,
	STAY,
}

var savedColorIndex = 0

var currentAIState = AI_STATES.WANDER

func GetStateName(index):
	return str(AI_STATES.keys()[index])

func SetPeepleName(newName):
	PeepleName = newName

func SetPeepleHobby(newHobby):
	PeepleHobby = newHobby

func GetPeepleName():
	return PeepleName

func GetPeepleHobby():
	if PeepleHobby == "":
		PeepleManager.AssignRandomHobby(self)
	return PeepleHobby

func GetHappiness():
	return Happiness

func GetFaceTexture():
	return $Face.texture

func GetShirtColor():
	return $Sprite2D.modulate

func _exit_tree():
	HappinessUpdate()

func _ready():
	SaveManager.AddToPersistGroup(self)
	var _OnLoadComplete = SaveManager.connect("OnLoadComplete", Callable(self, "OnLoadComplete"))
	var _OnDayTime = GameClock.connect("OnDayTime", Callable(self, "OnDayTimeExecute"))
	var _OnNightTime = GameClock.connect("OnNightTime", Callable(self, "OnNightTimeExecute"))
	var _OnHourUpdate = GameClock.connect("OnHourUpdate", Callable(self, "OnHourUpdate"))

	var _OnPeepleClick = InputManager.connect("OnPeepleClicked", Callable(self, "OnPeepleClick"))
	randomize()

	if bHasBeenSet == false:
		savedColorIndex = randi() % colors.size()
		$Sprite2D.modulate = colors[savedColorIndex]
		PeepleManager.AssignRandomName(self)
		Speed = Speed + randf_range(-50, 75)
	# TODO: Issue reshuffling parents... so that's why I have this timeout.
	await get_tree().create_timer(0.2).timeout
	PeepleManager.AddPeeple(self)
	var _OnHappinessUpdate = connect("OnHappinessUpdate", Callable(self, "HappinessUpdate"))
	emit_signal("OnHappinessUpdate")
	ChangeAIState(AI_STATES.GOHOME, true)

func AddHappiness(amount):
	Happiness += amount
	if Happiness < 0:
		Happiness = 0
	elif Happiness > 100:
		Happiness = 100
	emit_signal("OnHappinessUpdate")

func HappinessUpdate():
	pass

func OnLoadComplete():
	$Sprite2D.modulate = colors[savedColorIndex]

func Save():
	var dictionary = {
	"type" : "object",
	"filename" : get_scene_file_path(),
	"pos_x" : position.x,
	"pos_y" : position.y,
	"happiness" : Happiness,
	"color" : savedColorIndex,
	"speed" : Speed,
	"name" : GetPeepleName(),
	"hobby" : GetPeepleHobby()
	}
	return dictionary

func Load(dictData):
	bHasBeenSet = true
	position.x = dictData["pos_x"]
	position.y = dictData["pos_y"]
	Happiness = dictData["happiness"]
	Speed = dictData["speed"]
	savedColorIndex = dictData["color"]
	$Sprite2D.modulate = colors[savedColorIndex]
	SetPeepleName(dictData["name"])

	if dictData.has("hobby"):
		SetPeepleHobby(dictData["hobby"])

	Finder.GetPeepleGroup().add_child(self)
	RunAI()

func RunAI():
	if currentAIState == AI_STATES.WANDER:
		AIWANDER()
	elif currentAIState == AI_STATES.GOWORK:
		AIGOWORK()
	elif currentAIState == AI_STATES.FINDWORK:
		AIFINDWORK()
	elif currentAIState == AI_STATES.GOREC:
		AIGOREC()
	elif currentAIState == AI_STATES.FINDREC:
		AIFINDREC()
	elif currentAIState == AI_STATES.GOHOME:
		AIGOHOME()
	elif currentAIState == AI_STATES.FINDHOME:
		AIFINDHOME()
	elif currentAIState == AI_STATES.STAY:
		AISTAY()


func ChangeAIState(newState, bIsImmediate = false):
	#print(GetPeepleName() + " going from: " + GetStateName(currentAIState) + " to " + GetStateName(newState))
	currentAIState = newState
	if bIsImmediate:
		RunAI()
	visible = currentAIState != AI_STATES.STAY


func IsPathComplete():
	return CurrentPathIndex >= len(CurrentPath)

func AIWANDER():
	if IsPathComplete():
		SetTargetPosition(GetRandomPosition())

func AIGOWORK():
	if GameClock.IsWorkTime():
		if CheckWorkPlace():
			if IsAtPosition(GetWorkPlacePosition()):
				WorkPlace.Enter(self)
				ChangeAIState(AI_STATES.STAY, true)
				return
			SetTargetPosition(GetWorkPlacePosition())
		else:
			ChangeAIState(AI_STATES.FINDWORK, true)
	else:
		ChangeAIState(AI_STATES.WANDER, true)

func AIFINDWORK():
	FindJob()
	if CheckWorkPlace():
		ChangeAIState(AI_STATES.GOWORK, true)
		emit_signal("OnJobUpdate")
	else:
		ChangeAIState(AI_STATES.WANDER)
		emit_signal("OnJobUpdate")

func AIGOREC():
	if CheckRec():
		if IsAtPosition(GetRecPosition()):
			RecPlace.Enter(self)
			ChangeAIState(AI_STATES.STAY, true)
			return
		SetTargetPosition(GetRecPosition())
	else:
		ChangeAIState(AI_STATES.FINDREC, true)

func AIFINDREC():
	FindRec()
	if CheckRec():
		ChangeAIState(AI_STATES.GOREC, true)
		emit_signal("OnRecUpdate")
	else:
		ChangeAIState(AI_STATES.WANDER)
		emit_signal("OnRecUpdate")

func AIGOHOME():
	if CheckHouse():
		if IsAtPosition(GetHousePosition()):
			House.Enter(self)
			ChangeAIState(AI_STATES.STAY, true)
			return
		SetTargetPosition(GetHousePosition())
	else:
		ChangeAIState(AI_STATES.FINDHOME, true)

func AIFINDHOME():
	FindHouse()
	if CheckHouse():
		ChangeAIState(AI_STATES.GOHOME, true)
		emit_signal("OnHouseUpdate")
	else:
		ChangeAIState(AI_STATES.WANDER)
		emit_signal("OnHouseUpdate")

func AISTAY():
	pass

func GetWork():
	return WorkPlace

func GetWorkPlacePosition():
	return Vector2i(WorkPlace.global_position) + GameResources.TileOffset

func GetHouse():
	return House

func GetHousePosition():
	return Vector2i(House.global_position) + GameResources.TileOffset

func GetRecPlace():
	return RecPlace

func GetRecPosition():
	return Vector2i(RecPlace.global_position) + GameResources.TileOffset

func GetRandomPosition():

	var tile = Helper.GetTileInTilemap(global_position, Vector2(randf_range(-100, 100), randf_range(-100, 100)))
	if tile:
		if Helper.IsWaterTile(tile) == false:
			return Helper.GetTileGlobalCoord(tile)
	return global_position


func FindJob():
	WorkPlace = JobManager.FindJob(self)
	if WorkPlace:
		WorkPlace.connect("OnDestroyed", Callable(self, "OnFactoryDeath"))
		WorkPlace.Subscribe(self)
		PeepleManager.DeclareEmployed(self)
	else:
		PeepleManager.DeclaredUnEmployed(self)

func ProcessBuildingDeath():
	if is_instance_valid(get_tree()):
		# TODO: Can I get rid of this??
		await get_tree().create_timer(0.2).timeout
		ChangeAIState(AI_STATES.WANDER, true)
		bProcessLostSubscription = true

func FindHouse():
	House = HousingManager.FindHouse(self)
	if House:
		House.connect("OnDestroyed", Callable(self, "OnHouseDeath"))
		House.Subscribe(self)
		PeepleManager.DeclareHoused(self)
	else:
		PeepleManager.DeclareUnhoused(self)

func FindRec():
	RecPlace = RecManager.FindRec(self)
	if RecPlace:
		RecPlace.connect("OnDestroyed", Callable(self, "OnHouseDeath"))
		RecPlace.Subscribe(self)
		PeepleManager.DeclaredRecd(self)
	else:
		PeepleManager.DeclaredUnRecd(self)

func OnFactoryDeath():
	WorkPlace.disconnect("OnDestroyed", Callable(self, "OnFactoryDeath"))
	WorkPlace = null
	PeepleManager.DeclaredUnEmployed(self)
	ProcessBuildingDeath()

func OnHouseDeath():
	House = null
	PeepleManager.DeclareUnhoused(self)
	ProcessBuildingDeath()

func IsAtPosition(positionToCheck):
	return Vector2i(global_position) == positionToCheck

func CheckWorkPlace():
	if WorkPlace == null or is_instance_valid(WorkPlace) == false:
		WorkPlace = null
		return false
	return true

func CheckHouse():
	if House == null or is_instance_valid(House) == false:
		House = null
		return false
	return true

func CheckRec():
	if RecPlace == null or is_instance_valid(RecPlace) == false:
		RecPlace = null
		return false
	return true

func ExitCurrentBuilding():
	if CheckWorkPlace():
		if GetWork().IsAPeepleInBuilding(self):
			WorkPlace.Exit(self)

	# Check if exiting from home
	if CheckHouse():
		if GetHouse().IsAPeepleInBuilding(self):
			House.Exit(self)

	if CheckRec():
		if GetRecPlace().IsAPeepleInBuilding(self):
			RecPlace.Exit(self)

func SetTargetPosition(newTargetPosition):
	if Vector2i(newTargetPosition) == Vector2i(TargetPosition):
		return

	newTargetPosition = Vector2i(newTargetPosition)

	# Check if exiting from workplace
	ExitCurrentBuilding()

	bHasNewTarget = true
	TargetPosition = newTargetPosition
	CurrentPath = Helper.GetPathOnGrid(position, newTargetPosition)
	for x in range(0, len(CurrentPath)):
		CurrentPath[x] -= Vector2(GameResources.TileOffset)
	CurrentPathIndex = 0
	StartPosition = global_position

func MoveToTargetPosition():
	# TODO: MT: we should try to refactor this. I feel like the code is pretty identical
	if CheckWorkPlace() and GameClock.IsWorkTime():
		if IsAtPosition(GetWorkPlacePosition()):
			RunAI()
			return
	elif CheckHouse() and false == GameClock.IsWorkTime():
		if IsAtPosition(GetHousePosition()):
			RunAI()
			return


func _physics_process(delta):
	if CurrentPath.is_empty():
		return
	if CurrentPathIndex >= len(CurrentPath):
		StartPosition = TargetPosition
		CurrentPath.clear()
		RunAI()
	else:
		var distance = (Vector2(CurrentPath[CurrentPathIndex]) - global_position).length()
		if distance <= 0.0:
			CurrentPathIndex += 1
			return

		StartPosition = global_position
		SpeedDelta = (Speed + SpeedBonus) * delta
		var progress = SpeedDelta / distance
		progress = clampf(progress, 0.0, 1.0)
		if CurrentPathIndex < len(CurrentPath):
			global_position = lerp(StartPosition, Vector2(CurrentPath[CurrentPathIndex]), progress)

func _process(delta):
	MoveToTargetPosition()

func OnDayTimeExecute():
	if CheckHouse():
		AddHappiness(10)
	else:
		AddHappiness(-50)
		Helper.AddPopupText(position, "Missing House!!!!")

func OnNightTimeExecute():
	pass

func OnHourUpdate():
	if bProcessLostSubscription:
		bProcessLostSubscription = false
		return
	if GameClock.IsStartingWorkDay():
		ChangeAIState(AI_STATES.GOWORK)
	elif GameClock.IsLunchTime():
		ChangeAIState(AI_STATES.GOREC)
	elif GameClock.IsLunchFinishedTime():
		ChangeAIState(AI_STATES.GOWORK)
	elif GameClock.IsFinishingWorkDay():
		ChangeAIState(AI_STATES.GOHOME)
	RunAI()

func _on_Button_button_down():
	InputManager.PeepleClick(self)

func OnPeepleClick(obj):
	Helper.AddDescriptionPopup(obj)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	global_position = global_position.move_toward(global_position + safe_velocity, SpeedDelta)


func _on_timer_timeout():
	if CurrentPath.is_empty():
		return

	var tile = Helper.GetTileInTilemap(global_position)
	if tile:
		var travelSpeed = Helper.GetTileOnGridWeight(tile)
		# If you are above default, you are really slow
		# If you are at default, the speed bonus should be 0
		# If the travel speed is lower than default, you should move faster

		if travelSpeed == GameResources.DefaultTravelWeight:
			SpeedBonus = 0
		elif travelSpeed < GameResources.DefaultTravelWeight:
			SpeedBonus = lerp(0.0, Speed*2, 1 - (travelSpeed / GameResources.DefaultTravelWeight))
		else:
			# TODO: have a calculation for this when it's travel cost is horrid.Think of travelling through the mud.
			SpeedBonus = - 10
	else:
		SpeedBonus = 0
