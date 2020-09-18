extends Area2D
var item_id

func _on_Item_onground_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	Inventory.active_weapons.append(item_id)
	queue_free()
	
