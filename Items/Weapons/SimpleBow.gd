extends Weapon


func _init():
	shoot_speed = 800
	offset_x = 6
	offset_y = 4
	rot_offset = -90
	projectile_name = "Arrow"
	ranged = true
	melee = false
	texture = "simple_bow"
	cooldown = 0.2
	damage = 2
	autoattack = false
