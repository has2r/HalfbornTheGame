extends Projectile

var explosion_effect = load("res://Dusts/Explosion.tscn")

func _on_Area2D_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	var instance = explosion_effect.instance()
	instance.position.x = position.x
	instance.position.y = position.y
	instance.rotation = rotation
	get_tree().get_root().add_child(instance)
	queue_free()


func _on_Fireball_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	var instance = explosion_effect.instance()
	instance.position.x = position.x
	instance.position.y = position.y
	instance.rotation = rotation
	get_tree().get_root().add_child(instance)
	queue_free()
