extends StaticBody2D

var tile 
func _ready():
	$Sprite.region_rect = Utils.random_choice([Rect2(0, 0, 3, 5), Rect2(5, 0, 3, 5), Rect2(11, 0, 6, 5), Rect2(0, 6, 5, 3), Rect2(0, 10, 5, 6), Rect2(6, 10, 5, 6), Rect2(12, 10, 5, 6)])
	$Sprite.position.x+= randi()%15 + 5
	$Sprite.position.y+= randi()%5 + 5

