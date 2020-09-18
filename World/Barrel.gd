extends StaticBody2D

var explosion_effect = preload("res://Dusts/BarrelBroke.tscn")

var tile

func _on_Area2D_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	get_parent().set_cell(tile.x, tile.y, -1)
	var instance = explosion_effect.instance()
	instance.position.x = position.x + 5
	instance.position.y = position.y
	instance.rotation = rotation
	get_tree().get_root().add_child(instance)
	queue_free()
