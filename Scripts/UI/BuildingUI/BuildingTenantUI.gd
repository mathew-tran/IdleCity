extends Control

var Tenant

func _ready():
	if is_instance_valid(Tenant):
		$HBoxContainer/Label.text = Tenant.GetPeepleName()

func _on_button_button_up():
	if is_instance_valid(Tenant):
		InputManager.PeepleClick(Tenant)
