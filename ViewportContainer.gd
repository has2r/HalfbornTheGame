extends ViewportContainer

export var DESIRED_RESOLUTION = Vector2(320, 180)
var scaling_factor = 0
var vp

func _ready():
	self.vp = self.get_viewport()
	self.vp.connect(
		"size_changed", self, "on_vp_size_change"
	)
	self.on_vp_size_change()

func on_vp_size_change():
	var scale_vector = self.vp.size / self.DESIRED_RESOLUTION
	var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
	self.scaling_factor = new_scaling_factor
	var vp_size = DESIRED_RESOLUTION * self.scaling_factor
	self.margin_left = -vp_size[0] / 2
	self.margin_right = vp_size[0] / 2
	self.margin_top = -vp_size[1] / 2
	self.margin_bottom = vp_size[1] / 2
