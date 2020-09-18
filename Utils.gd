extends Node2D
var droppedItem = preload("res://Items/ItemDrop.tscn")

var player setget ,_get_player
var enemies_count
var area_dark = false

func _get_player():
	return player if is_instance_valid(player) else null
	
func random_choice(array):
	return array[randi() % array.size()]
	
func drop_item(item_name, item_pos):
	var drop = droppedItem.instance()
	var sprite = load("res://Items/Weapons/" + item_name + ".png")
	drop.item_id = item_name
	drop.get_node("Sprite").set_texture(sprite)
	drop.global_position = item_pos
	get_tree().get_root().call_deferred("add_child", drop)
	
func spawn_enemy(enemy_name, enemy_pos):
	var enemy_scene = load("res://Enemies/" + enemy_name + ".tscn")
	var enemy_instance = enemy_scene.instance()
	enemy_instance.global_position = enemy_pos
	get_tree().get_root().get_node("World/YSort").add_child(enemy_instance)
	
