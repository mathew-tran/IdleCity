extends Panel

var trackedPeeple = null
var bIsFollowing : bool = false
var bIsActive : bool = false

@onready var HappinessBar : ProgressBar = $RightSide/ProgressBar
@onready var PeepleNameLabel : Label = $LeftSide/PeepleName
@onready var PeepleFace : Sprite2D = $LeftSide/PeepleFace
@onready var PeepleBody : Sprite2D = $LeftSide/PeepleBody

@onready var FollowButton : Button = $LeftSide/FollowButton

@onready var WorkControl = $RightSide/WorkControl
@onready var HouseControl = $RightSide/HouseControl

func _ready():
	Finder.GetPlayer().connect("OnPlayerModeChange", Callable(self, "PlayerModeChange"))
	visible = false

func PlayerModeChange(bIsBuildMode):
	if bIsBuildMode:
		visible = false
	else:
		if bIsActive:
			visible = true


func Show(peeple):
	bIsActive = true
	StopFollowing()
	if trackedPeeple:
		trackedPeeple.disconnect("OnHappinessUpdate", Callable(self, "UpdateUI"))
		trackedPeeple.disconnect("OnJobUpdate", Callable(self, "JobUpdate"))
		trackedPeeple.disconnect("OnHouseUpdate", Callable(self, "HouseUpdate"))
	trackedPeeple = peeple
	trackedPeeple.connect("OnHappinessUpdate", Callable(self, "UpdateUI"))
	trackedPeeple.connect("OnJobUpdate", Callable(self, "JobUpdate"))
	trackedPeeple.connect("OnHouseUpdate", Callable(self, "HouseUpdate"))

	HouseControl.connect("HouseFollowClicked", Callable(self, "HouseFollowClicked"))
	WorkControl.connect("JobFollowClicked", Callable(self, "JobFollowClicked"))
	PeepleNameLabel.text = peeple.GetPeepleName()
	PeepleFace.texture = peeple.GetFaceTexture()
	PeepleBody.modulate = peeple.GetShirtColor()

	UpdateUI()
	JobUpdate()
	HouseUpdate()
	visible = true

func UpdateUI():
	HappinessBar.value = trackedPeeple.GetHappiness()
	var gradeValue = GameResources.GetHappinessGrading(trackedPeeple.GetHappiness())
	if GameResources.GRADE.A == gradeValue:
		HappinessBar.modulate = Color.GREEN
	if GameResources.GRADE.B == gradeValue:
		HappinessBar.modulate = Color.GREEN_YELLOW
	if GameResources.GRADE.C == gradeValue:
		HappinessBar.modulate = Color.YELLOW
	if GameResources.GRADE.D == gradeValue:
		HappinessBar.modulate = Color.RED

	if bIsFollowing:
		FollowButton.text = "Unfollow"
	else:
		FollowButton.text = "Follow"

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
			StopFollowing()


func HouseFollowClicked():
		if trackedPeeple:
			if trackedPeeple.GetHouse():
				Helper.FocusCamera(trackedPeeple.GetHouse())
				StopFollowing()
