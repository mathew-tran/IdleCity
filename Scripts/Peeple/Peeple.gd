extends Sprite2D

var TargetPosition = Vector2()
var bHasNewTarget = false
var WorkPlace = null
var House = null

@export var Speed = 125

var Happiness = 50

signal OnHappinessUpdate
signal OnJobUpdate
signal OnHouseUpdate

var TargetOffset = Vector2(16,16)

var colors = [Color(1.0, 1.0, 1.0, 1.0),
		  Color(.20, 1.0, 0.2, 1.0),
		  Color(0.5, 0.6, 1.0, 1.0)]

var bProcessLostSubscription = false
var PeepleName = ""
var bHasBeenSet = false
var SpeedDelta : float

enum AI_STATES {
	WANDER,
	GOWORK,
	FINDWORK,
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
	
func GetPeepleName():
	return PeepleName
		
func GetHappiness():
	return Happiness

func GetTexture():
	return $Sprite2D.texture

func GetModulation():
	return $Sprite2D.modulate
	
func _exit_tree():
	HappinessUpdate()
	
func _ready():
	SaveManager.AddToPersistGroup(self)
	var _OnLoadComplete = SaveManager.connect("OnLoadComplete", Callable(self, "OnLoadComplete"))	
	var _OnDayTime = GameClock.connect("OnDayTime", Callable(self, "OnDayTimeExecute"))
	var _OnNightTime = GameClock.connect("OnNightTime", Callable(self, "OnNightTimeExecute"))
	var _OnHourUpdate = GameClock.connect("OnHourUpdate", Callable(self, "OnHourUpdate"))
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
	"name" : GetPeepleName()
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
	
	Finder.GetPeepleGroup().add_child(self)
	
func RunAI():
	if currentAIState == AI_STATES.WANDER:
		AIWANDER()
	elif currentAIState == AI_STATES.GOWORK:
		AIGOWORK()
	elif currentAIState == AI_STATES.FINDWORK:
		AIFINDWORK()
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
		
	
func AIWANDER():
	var bIsPositive = randi() % 2
	var newPosition = global_position
	if bIsPositive:
		newPosition += GetRandomPosition()
	else:
		newPosition -= GetRandomPosition()
	SetTargetPosition(newPosition)
	if GameClock.IsWorkTime():
		ChangeAIState(AI_STATES.GOWORK, true)
	else:
		ChangeAIState(AI_STATES.GOHOME, true)
	
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
	return WorkPlace.global_position + TargetOffset

func GetHouse():
	return House
		
func GetHousePosition():
	return House.global_position + TargetOffset

func GetRandomPosition():
	return Vector2(randi() % 30, randi() % 30)
	
		
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

	
func OnFactoryDeath():
	WorkPlace.disconnect("OnDestroyed", Callable(self, "OnFactoryDeath"))
	WorkPlace = null
	PeepleManager.DeclaredUnEmployed(self)
	ProcessBuildingDeath()
	# Wait for factory to die.
	
	
	
func OnHouseDeath():
	House.disconnect("OnDestroyed", Callable(self, "OnHouseDeath"))
	House = null
	PeepleManager.DeclareUnhoused(self)
	ProcessBuildingDeath()
	
	
func IsAtPosition(positionToCheck):
	return global_position == positionToCheck
	
		
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
	
func SetTargetPosition(newTargetPosition):
	if global_position == newTargetPosition:		
		return
	# Check if exiting from workplace
	if CheckWorkPlace():
		if IsAtPosition(GetWorkPlacePosition()):
			WorkPlace.Exit(self)
	
	# Check if exiting from home
	if CheckHouse():
		if IsAtPosition(GetHousePosition()):
			House.Exit(self)
			
	bHasNewTarget = true
	TargetPosition = newTargetPosition
	$NavigationAgent2D.target_position = newTargetPosition
	
func MoveToTargetPosition():
	if CheckWorkPlace() and GameClock.IsWorkTime():
		if IsAtPosition(GetWorkPlacePosition()):
			RunAI()
			return
	elif CheckHouse() and false == GameClock.IsWorkTime():
		if IsAtPosition(GetHousePosition()):
			RunAI()
			return
	
	
func _physics_process(delta):
	if $NavigationAgent2D.is_navigation_finished():
		global_position = TargetPosition
		return

	SpeedDelta = Speed * delta
	var nextPathPosition : Vector2 = $NavigationAgent2D.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(nextPathPosition) * SpeedDelta
	_on_navigation_agent_2d_velocity_computed(new_velocity)
		
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
	elif GameClock.IsFinishingWorkDay():
		ChangeAIState(AI_STATES.GOHOME)
	RunAI()

func _on_Button_button_down():
	print(GetPeepleName() + " get info!")
	Helper.FocusCamera(self)
	Helper.AddDescriptionPopup(self)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	global_position = global_position.move_toward(global_position + safe_velocity, SpeedDelta)
