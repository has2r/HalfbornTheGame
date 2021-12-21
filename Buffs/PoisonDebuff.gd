extends Buff

var bubbles_effect = load("res://Dusts/PoisonBubbles.tscn")

func _ready():
	var instance = bubbles_effect.instance()
	instance.position += Vector2(0,-12)
	get_parent().call_deferred("add_child", instance)
func _process(delta):
	get_parent().get_node("Sprite").modulate = Color(0.68, 1, 0.65, 1)
	
