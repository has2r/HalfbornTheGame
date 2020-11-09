extends Node2D
class_name Weapon


var projectile_name = "Arrow"
var projectile = load("res://Projectiles/" + projectile_name + ".tscn")

onready var player = get_parent()
var cooldownTimer
var cooldown = 0.3
var damage = 1 


onready var texture = $Sprite.texture
var offset_x = 9
var offset_y = 4
var rot_offset = 0

var melee = false
var ranged
var magic 
var mana_cost = 0

var autoattack = true
var shoot_speed = 200

var is_attacking = false

	
func _ready():
	z_index = 0
	cooldownTimer = Timer.new()
	cooldownTimer.set_one_shot(false)
	cooldownTimer.set_wait_time(cooldown)
	cooldownTimer.connect("timeout", self, "_attack_complete")
	add_child(cooldownTimer)
func _process(_delta):
	projectile = load("res://Projectiles/" + projectile_name + ".tscn")
	show_behind_parent = true
	if Inventory.faceRight:
		$Sprite.scale.x = 1 
		position.x = offset_x
		position.y = offset_y
	else:
		$Sprite.scale.x = -1 
		position.x = -offset_x
		position.y = offset_y

	
		
func shoot(_target_position : Vector2):
	if (magic):
		if (Stats.mana >= mana_cost and !is_attacking):
			Stats.mana-=mana_cost
		else: 
			return
	if (ranged):
		if (Inventory.ammo > 0 and !is_attacking):
			Inventory.ammo-=1
		else: 
			return
	if (!is_attacking):
		is_attacking = true
		var proj_instance = projectile.instance()
		proj_instance.position.x = get_parent().position.x + cos(get_local_mouse_position().angle()) * 20 
		proj_instance.position.y = get_parent().position.y + sin(get_local_mouse_position().angle()) * 20 
		proj_instance.rotation = get_local_mouse_position().angle() + 1.5
		proj_instance.damage = damage
		var direction = (get_global_mouse_position() - get_parent().position).normalized()
		proj_instance.linear_velocity = direction * shoot_speed
		get_tree().get_root().add_child(proj_instance)
		cooldownTimer.start()
		

func attack() -> bool:
	assert(false)
	return false

func _attack_complete():
	is_attacking = false
