extends Area2D

var hit = false
var tile

func _on_Area2D_area_entered(_area):
	if (!hit):
		get_parent().set_cell(tile[0], tile[1], 2, false, false, false, Vector2(1, 0))
		hit = true
	else:
		get_parent().set_cell(tile[0], tile[1], 2, false, false, false, Vector2(0, 0))
		hit = false
