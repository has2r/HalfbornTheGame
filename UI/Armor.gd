extends TextureRect

func _input(_event):
	texture = load("res://Items/Armor/" + Inventory.current_armor + ".png")
