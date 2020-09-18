extends Area2D

var targets_array = []

func _ready():
	var deathTimer = Timer.new()
	deathTimer.set_one_shot(true)
	deathTimer.set_wait_time(0.2)
	deathTimer.connect("timeout", self, "queue_free")
	add_child(deathTimer)
	deathTimer.start()
func _on_Node2D_area_entered(area):
	targets_array.push_front(area.get_parent())
	

