extends Particles2D

func _process(delta):
	position = get_parent().get_node("Sprite").position
	rotation = get_parent().get_node("Sprite").rotation

