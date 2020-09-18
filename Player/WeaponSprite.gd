extends Node2D
 
onready var sprite = $Sprite
var target_position 
var counter = 0

var shoot_speed = 200


	
func _process(delta):
	sprite.texture = load("res://items/"+ WeaponsList.current_weapon + ".png")
	show_behind_parent = true
	if WeaponsList.faceRight:
		sprite.scale.x = 1 
		position.x = 5
		#rotation += target_position.angle() - 19.5
	else:
		sprite.scale.x = -1 
		position.x = -5
	counter+=1
		
	if Input.is_action_just_pressed("attack"):
		var bullet_instance = arrow.instance()
		bullet_instance.position = get_parent().position
		bullet_instance.rotation = get_local_mouse_position().angle() + 1.5
		var direction = (get_global_mouse_position() - get_parent().position).normalized()
		bullet_instance.linear_velocity = direction * shoot_speed
		get_tree().get_root().add_child(bullet_instance)

	

 
