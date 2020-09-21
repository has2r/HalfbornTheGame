extends Sprite

#var char_tex = load("res://Player/Player.png") 

func _ready():
	Inventory.connect("armor_changed", self, "set_armor")
	
func set_armor():
	texture = load("res://Items/Armor/"+Inventory.current_armor+".png")
