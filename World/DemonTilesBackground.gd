extends TileMap


var door_scene = preload("res://World/Door.tscn")

func place_tile_scenes():
	var door_tiles = get_used_cells_by_id(2)
	
	tiles_instancing(door_tiles, door_scene)
	
func tiles_instancing(tile_array, tile_scene):
	for tile in tile_array:
		var tile_instance = tile_scene.instance()
		tile_instance.position = map_to_world(tile)
		tile_instance.tile = tile
		add_child(tile_instance)
