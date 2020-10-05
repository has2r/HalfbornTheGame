extends Area2D
var item_id
var item_type
var quantity
		
func _on_Item_onground_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	match item_type:
		"Weapons":
			Inventory.active_weapons.append(item_id)
		"Armor":
			Inventory.active_armor.append(item_id)
		"Accessories":
			Inventory.active_accessories.append(item_id)
		"":
			Inventory.money += quantity
	queue_free()
	
