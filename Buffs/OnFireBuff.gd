extends Node

var bubbles_effect = load("res://Dusts/OnFireSparks.tscn")

var endless
var timer
var hurt_timer
var buff_name = "OnFireBuff"
var duration

func _ready():
	if !endless:
		timer = Timer.new()
		timer.set_wait_time(duration)
		timer.connect("timeout", self, "disappear")
		add_child(timer)
		timer.start()
		
	hurt_timer = Timer.new()
	hurt_timer.set_wait_time(2)
	hurt_timer.connect("timeout", self, "deal_damage")
	hurt_timer.set_one_shot(false)
	add_child(hurt_timer)
	hurt_timer.start()

	var instance = bubbles_effect.instance()
	instance.position += Vector2(0,-12)
	get_parent().call_deferred("add_child", instance)
	get_parent().get_node("Sprite").modulate = Color(1, 0.27, 0, 1)

func disappear():
	if get_parent() != null:
		get_parent().get_node_or_null("OnFireSparks").queue_free()
		get_parent().get_node_or_null("Sprite").modulate = Color(1, 1, 1, 1)
	queue_free()
	
func deal_damage():
	get_parent().stats.health-=5
