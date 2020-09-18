extends Weapon

var cursor_area = preload("res://CursorArea.tscn")
var targets_array

func _init():
	shoot_speed = 400
	offset_x = 8
	projectile_name = "LightSword"
	magic = true
	texture = "strange_card"
	cooldown = 0.2
	damage = 0
	mana_cost = 0
	autoattack = false
	
var target_position 


func shoot(_target_position : Vector2):
	var cursor_area_instance = cursor_area.instance()
	cursor_area_instance.position = get_global_mouse_position()
	get_tree().get_root().add_child(cursor_area_instance)
	yield(cursor_area_instance, "area_entered")
	targets_array = cursor_area_instance.targets_array
	if (targets_array.size()>0):
		pass
	else:
		return
		
	if (Stats.mana >= mana_cost and !is_attacking):
		Stats.mana-=mana_cost
	else: 
		return
		
	if (!is_attacking):
		is_attacking = true
		for i in range(0, targets_array.size()):
			target_position = targets_array[i]
		
			var proj_instance = projectile.instance()
			var proj_instance_1 = projectile.instance()
			var proj_instance_2 = projectile.instance()
		
			proj_instance.position.x = target_position.position.x - 10
			proj_instance.position.y = target_position.position.y - 60
			proj_instance.target_pos = target_position.position - Vector2(0, 25)
			proj_instance.enemy = weakref(target_position)
		
			proj_instance_1.position.x = target_position.position.x + 8
			proj_instance_1.position.y = target_position.position.y - 60
			proj_instance_1.target_pos = target_position.position - Vector2(0, 15)
			proj_instance_1.enemy = weakref(target_position)
		
			proj_instance_2.position.x = target_position.position.x - 15
			proj_instance_2.position.y = target_position.position.y - 60
			proj_instance_2.target_pos = target_position.position - Vector2(0, 5)
			proj_instance_2.enemy = weakref(target_position)
			proj_instance_2.z_index = 1
		
		
			get_tree().get_root().call_deferred("add_child", proj_instance)
			get_tree().get_root().call_deferred("add_child", proj_instance_1)
			get_tree().get_root().call_deferred("add_child", proj_instance_2)
			cooldownTimer.start()
	

		
