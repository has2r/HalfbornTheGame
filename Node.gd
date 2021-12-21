extends Node

func _ready():
	get_viewport().connect("size_changed", self, "window_resize")

func window_resize():
	get_viewport().set_size_override(true, OS.get_window_size())
