extends Weapon


func _ready():
	shoot_speed = 1
	offset_x = 9
	offset_y = 4
	projectile_name = "SwordSlash"
	melee = true
	texture = "simple_sword"
var target_position 
var angle

func shoot(_target_position : Vector2):
	target_position = get_local_mouse_position()
	angle = target_position.angle()
	var proj_instance = projectile.instance()
	#proj_instance.position = aget_parent().position 
	proj_instance.position.x = get_parent().position.x + cos(angle) * 20
	proj_instance.position.y = get_parent().position.y + sin(angle) * 20
	proj_instance.rotation = get_local_mouse_position().angle() + 1.5
	var direction = (get_global_mouse_position() - get_parent().position).normalized()
	proj_instance.linear_velocity = direction * shoot_speed
	#get_tree().get_root().add_child(proj_instance)
	
func _process(_delta):
	if Inventory.isAttacking:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = false

	else:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = true
