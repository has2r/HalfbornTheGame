extends Area2D


var hit = false
var tile

func _on_Area2D_area_entered(_area):
	if (!hit):
		Utils.drop_item("StrangeCard", global_position, "Weapons")
		get_parent().set_cell(tile[0], tile[1], 18, false, false, false, Vector2(0, 1))
		hit = true
