extends Camera2D

export var DESIRED_RESOLUTION = Vector2(320, 180)
var vp
var scaling_factor = 1

func _ready():
	vp = get_viewport()
	vp.connect(
	"size_changed", self, "on_vp_size_change")
	on_vp_size_change()

#func on_vp_size_change():
	#var scale_vector = vp.size / DESIRED_RESOLUTION
	#var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
	#if new_scaling_factor != scaling_factor:
			#scaling_factor = new_scaling_factor
			#zoom = Vector2(1 / scaling_factor, 1 / scaling_factor)
			
			
			
func on_vp_size_change():
	var scale_vector = vp.size / DESIRED_RESOLUTION
	var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
	if new_scaling_factor != scaling_factor:
		scaling_factor = new_scaling_factor
		var default_transform = Transform2D(Vector2(1, 0), Vector2(0, 1), Vector2())
		vp.canvas_transform = (default_transform.scaled(Vector2(scaling_factor, scaling_factor)))
			

