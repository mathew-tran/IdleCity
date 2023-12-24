extends Panel

var trackedPeeple = null
var bIsFollowing : bool = false
var bIsActive : bool = false

@onready var HappinessBar = $RightSide/VBoxContainer/HappinessBar
@onready var HungerBar = $RightSide/VBoxContainer/Hunger
@onready var PeepleNameLabel : Label = $LeftSide/PeepleName
@onready var PeepleHobbyLabel : Label = $LeftSide/PeepleHobby
@onready var PeepleFace : Sprite2D = $LeftSide/PeepleFace
@onready var PeepleBody : Sprite2D = $LeftSide/PeepleBody

@onready var FollowButton : Button = $LeftSide/FollowButton

@onready var WorkControl = $RightSide/WorkControl
@onready var HouseControl = $RightSide/HouseControl

func _ready():
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "PlayerModeChange"))
	visible = false
	HouseControl.connect("HouseFollowClicked", Callable(self, "HouseFollowClicked"))
	WorkControl.connect("JobFollowClicked", Callable(self, "JobFollowClicked"))


func PlayerModeChange(bIsBuildMode):
	if bIsBuildMode:
		visible = false
		StopFollowing()


func Show(peeple):
	bIsActive = true
	StopFollowing()
	if trackedPeeple:
		trackedPeeple.disconnect("OnHappinessUpdate", Callable(self, "UpdateUI"))
		trackedPeeple.disconnect("OnSatietyUpdate", Callable(self, "UpdateHungerUI"))
		trackedPeeple.disconnect("OnJobUpdate", Callable(self, "JobUpdate"))
		trackedPeeple.disconnect("OnHouseUpdate", Callable(self, "HouseUpdate"))
	trackedPeeple = peeple
	trackedPeeple.connect("OnHappinessUpdate", Callable(self, "UpdateUI"))
	trackedPeeple.connect("OnJobUpdate", Callable(self, "JobUpdate"))
	trackedPeeple.connect("OnHouseUpdate", Callable(self, "HouseUpdate"))
	trackedPeeple.connect("OnSatietyUpdate", Callable(self, "UpdateHungerUI"))

	PeepleNameLabel.text = peeple.GetPeepleName()
	PeepleFace.texture = peeple.GetFaceTexture()
	PeepleBody.modulate = peeple.GetShirtColor()
	PeepleHobbyLabel.text = peeple.GetPeepleHobby()

	UpdateUI()
	UpdateHungerUI()
	JobUpdate()
	HouseUpdate()
	visible = true

func UpdateUI():
	var happinessProgressBar = HappinessBar.get_node("ProgressBar")
	happinessProgressBar.value = trackedPeeple.GetHappiness()
	var gradeValue = GameResources.GetHappinessGrading(trackedPeeple.GetHappiness())
	if GameResources.GRADE.A == gradeValue:
		happinessProgressBar.modulate = Color.GREEN
	if GameResources.GRADE.B == gradeValue:
		happinessProgressBar.modulate = Color.GREEN_YELLOW
	if GameResources.GRADE.C == gradeValue:
		happinessProgressBar.modulate = Color.YELLOW
	if GameResources.GRADE.D == gradeValue:
		happinessProgressBar.modulate = Color.RED

	if bIsFollowing:
		FollowButton.text = "Unfollow"
	else:
		FollowButton.text = "Follow"

func UpdateHungerUI():
	var hungerProgressBar = HungerBar.get_node("ProgressBar")
	hungerProgressBar.value = trackedPeeple.GetSatiety()
	var gradeValue = GameResources.GetHappinessGrading(trackedPeeple.GetSatiety())
	if GameResources.GRADE.A == gradeValue:
		hungerProgressBar.modulate = Color.GREEN
	if GameResources.GRADE.B == gradeValue:
		hungerProgressBar.modulate = Color.GREEN_YELLOW
	if GameResources.GRADE.C == gradeValue:
		hungerProgressBar.modulate = Color.YELLOW
	if GameResources.GRADE.D == gradeValue:
		hungerProgressBar.modulate = Color.RED

func JobUpdate():
	if trackedPeeple:
		WorkControl.Update(trackedPeeple)

func HouseUpdate():
	if trackedPeeple:
		HouseControl.Update(trackedPeeple)

func StopFollowing():
	if bIsFollowing:
		Helper.FollowCamera(null)
		bIsFollowing = false
		UpdateUI()

func _on_ToolButton_button_up():
	bIsActive = false
	visible = false
	StopFollowing()

func _on_Button_button_up():
	bIsFollowing = !bIsFollowing
	if trackedPeeple:
		if bIsFollowing:
			Helper.FollowCamera(trackedPeeple)
		else:
			Helper.FollowCamera(null)

	UpdateUI()

func JobFollowClicked():
	if trackedPeeple:
		if trackedPeeple.GetWork():
			Helper.FocusCamera(trackedPeeple.GetWork())
			InputManager.PlayContextClick(trackedPeeple.GetWork())
			StopFollowing()


func HouseFollowClicked():
		if trackedPeeple:
			if trackedPeeple.GetHouse():
				Helper.FocusCamera(trackedPeeple.GetHouse())
				InputManager.PlayContextClick(trackedPeeple.GetHouse())
				StopFollowing()
