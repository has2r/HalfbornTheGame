extends Node

var bubbles_effect = load("res://Dusts/OnFireSparks.tscn")

var endless
var timer
var buff_name = "OnFireBuff"
var duration

func _ready():
	Inventory.connect("weapon_changed", self, "set_effect")
	if !endless:
		timer = Timer.new()
		timer.set_wait_time(duration)
		timer.connect("timeout", self, "queue_free")
		timer.start()
		add_child(timer)
	set_effect()
	buff_name = "FireAttack"
func set_effect():
	var weapon_node = get_parent().weaponSprite
	weapon_node.firing = true
	get_parent().actualSprite.modulate = Color(1, 0.27, 0, 1)
	var instance = bubbles_effect.instance()
	var shape = get_parent().actualSprite.texture.get_size() / Vector2(2,2)
	instance.process_material.emission_box_extents = Vector3(shape.x, shape.y, 1)
	weapon_node.call_deferred("add_child", instance)
