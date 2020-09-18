extends TextureRect

func _input(_event):
	texture = load("res://Items/Weapons/" + Inventory.current_weapon + ".png")
