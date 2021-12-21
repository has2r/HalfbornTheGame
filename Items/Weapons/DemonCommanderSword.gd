extends Weapon


func _ready():
	shoot_speed = 1
	offset_x = 15
	offset_y = 2
	projectile_name = "FireTrailPro"
	melee = true
	texture = "simple_sword"
var target_position 
var angle

	
func _process(_delta):
	if Inventory.isAttacking:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = false
		
		

	else:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = true

func shoot(_target_position : Vector2):
	if (!is_attacking):
		is_attacking = true
		var proj_instance = projectile.instance()
		proj_instance.position.x = get_parent().position.x + cos(get_local_mouse_position().angle()) * 20 
		proj_instance.position.y = get_parent().position.y + sin(get_local_mouse_position().angle()) * 20 
		proj_instance.rotation = get_local_mouse_position().angle()
		proj_instance.damage = damage
		get_tree().get_root().add_child(proj_instance)
		cooldownTimer.start()
func _on_RigidBody2D_area_entered(area):
	if firing:
		if (area.collision_layer==4):
			Utils.add_buff("OnFireBuff", area.get_parent().name, false, 5)
