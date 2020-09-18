extends RigidBody2D
class_name Projectile

var damage = 1
var knockback_vector = Vector2(0,0)
var friendly = false
var hostile = false

func _ready():
	if(Utils.area_dark):
		var light_node = Light2D.new()
		light_node.texture = load("res://Player/light.png")
		add_child(light_node)


func _on_Hitbox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	queue_free()


func _on_Node2D_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	queue_free()
