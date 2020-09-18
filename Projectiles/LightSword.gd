extends Projectile

var enemy 
var target_pos

func _ready():
	var deathTimer = Timer.new()
	deathTimer.set_one_shot(true)
	deathTimer.set_wait_time(5)
	deathTimer.connect("timeout", self, "queue_free")
	add_child(deathTimer)
	deathTimer.start()
	
func _process(_delta):
	if (!enemy.get_ref()):
		queue_free()
	else:
		enemy.get_ref().state = 5
		if (global_position.y < target_pos.y):
			linear_velocity = Vector2(0, 200)
		else:
			linear_velocity = Vector2(0,0)
			mode = MODE_STATIC

func _on_LightSword_tree_exiting():
	if (!enemy.get_ref()):
		return
	else:
		enemy.get_ref().state = 2
