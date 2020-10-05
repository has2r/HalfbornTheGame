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

	
func _process(_delta):
	if Inventory.isAttacking:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = false

	else:
		$Sprite/RigidBody2D/CollisionShape2D.disabled = true
