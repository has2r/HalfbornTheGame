extends Weapon


func _ready():
	shoot_speed = 1
	offset_x = 9
	offset_y = 4
	projectile_name = "SwordSlash"
	melee = true
	texture = "HorizonClaws"
var target_position 
var angle

	
func _process(_delta):
	if Inventory.isAttacking:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = false

	else:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = true


func _on_RigidBody2D_area_entered(area):
	if firing:
		if (area.collision_layer==4):
			Utils.add_buff("OnFireBuff", area.get_parent().name, false, 5)
