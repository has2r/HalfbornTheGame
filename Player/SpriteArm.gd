extends AnimatedSprite

var char_tex = load("res://Player/DefaultArmor.tres") 

func _ready():
	set_process_input(true)
	frames = char_tex

func _input(_event):
	if Input.is_action_just_pressed("armor_change"):
		frames = load("res://Player/IronArmor.tres")
