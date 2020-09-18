extends Weapon


func _init():
	shoot_speed = 400
	offset_x = 8
	projectile_name = "Fireball"
	magic = true
	texture = "fireball_staff"
	cooldown = 0.4
	damage = 5
	mana_cost = 1
