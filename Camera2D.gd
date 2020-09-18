extends Camera2D

onready var topLeft = $Corners/TopLeft
onready var bottomRight = $Corners/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x

