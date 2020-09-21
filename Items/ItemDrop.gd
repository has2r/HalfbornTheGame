extends Area2D
var item_id
var threshold_reached = false
func _process(delta):
	if $Light2D.energy >= 1:
		threshold_reached = true
	if $Light2D.energy <= 0:
		threshold_reached = false
	if (threshold_reached):
		$Light2D.energy-=0.01
	else:
		$Light2D.energy+=0.01
		
func _on_Item_onground_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	Inventory.active_weapons.append(item_id)
	queue_free()
	
