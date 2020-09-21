extends AnimatedSprite


func _ready():
	Inventory.connect("armor_changed", self, "set_armor")
	
func set_armor():
	frames = load("res://Items/Armor/"+Inventory.current_armor+".tres")
