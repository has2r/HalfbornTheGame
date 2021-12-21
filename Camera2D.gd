extends Camera2D

export(NodePath) var foreground

func _ready():
	foreground = get_node(foreground)
func _process(delta):
	position.x = int(foreground.position.x)
	position.y = int(foreground.position.y)
	force_update_scroll()
