extends Area2D
var item_id
var item_type
var quantity
var player_near = false

var limit_reached = false

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.connect("timeout", self, "revert_movement")
	add_child(timer)
	timer.start()
	
func _physics_process(_delta):
	if limit_reached:
		position.y-=0.1
	else:
		position.y+=0.1
		
func revert_movement():
	limit_reached = false if limit_reached else true
		
func _on_Item_onground_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	player_near = true
	

	
func _input(_event):
	if Input.is_action_pressed("pick_up") and player_near:
		match item_type:
			"Weapons/":
				if Input.is_action_pressed("pick_up"):
					Inventory.active_weapons.append(item_id)
					queue_free()
			"Armor/":
				if Input.is_action_pressed("pick_up"):
					Inventory.active_armor.append(item_id)
					queue_free()
			"Accessories/":
				if Input.is_action_pressed("pick_up"):
					Inventory.active_accessories.append(item_id)
					Inventory.emit_signal("accessory_changed")
					queue_free()
			"Consumables/":
				if Input.is_action_pressed("pick_up"):
					Inventory.active_consumables.append(item_id)
					queue_free()
	
	


func _on_Item_onground_area_shape_exited(_area_id, _area, _area_shape, _self_shape):
	player_near = false
