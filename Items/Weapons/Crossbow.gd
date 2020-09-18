extends Weapon

func _init():
	shoot_speed = 800
	offset_x = 10
	offset_y = 4
	rot_offset= -45
	projectile_name = "Bolt"
	ranged = true
	texture = "Crossbow"
	cooldown = 0.3
	damage = 4
