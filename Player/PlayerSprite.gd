extends Sprite

var char_tex = load("res://Player/Player.png") 

func _ready():
	set_process_input(true)
	texture = char_tex

func _input(_event):
	if Input.is_action_just_pressed("armor_change"):
		texture = load("res://Items/Armor/IronArmor.png")
