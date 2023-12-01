extends Navigation2D


signal OnNavigationLoaded
var bIsLoaded = false
func _ready():
	emit_signal("OnNavigationLoaded")
	bIsLoaded = true
	
func IsLoaded():
	return bIsLoaded
