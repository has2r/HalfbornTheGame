extends Node2D


var tile

# Called when the node enters the scene tree for the first time.
func _ready():
	var type = get_parent().get_cell_autotile_coord(tile[0], tile[1])
	if type[0]==0:
		position+=Vector2(1,7)
		$Light2D.texture = load(("res://World/FireLight.png"))
	if type[0]==1:
		position+=Vector2(7,4)
	if type[0]==2:
		position+=Vector2(12,7)



