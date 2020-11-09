extends Area2D
var item_id
var quantity
var limit_reached = false

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.connect("timeout", self, "revert_movement")
	add_child(timer)
	timer.start()
	
func _physics_process(_delta):
	if limit_reached:
		position.y-=0.05
	else:
		position.y+=0.05
		
func revert_movement():
	limit_reached = false if limit_reached else true
		
func _on_Item_onground_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	match item_id:
		"CopperCoin":
			Inventory.money += quantity
		"AmmoDrop":
			Inventory.ammo += quantity
	queue_free()
	
