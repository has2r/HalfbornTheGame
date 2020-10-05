extends TileMap


var rare_chest_scene = preload("res://World/ChestRare.tscn")
var epic_chest_scene = preload("res://World/ChestEpic.tscn")
var legendary_chest_scene = preload("res://World/ChestLegendary.tscn")
var barrel_scene = preload("res://World/Barrel.tscn")
var torch_light_scene = preload("res://World/FireLight.tscn")
#var grave_scene = preload("res://World/Grave.tscn")

func place_tile_scenes():
	var rare_chest_tiles = get_used_cells_by_id(17)
	var epic_chest_tiles = get_used_cells_by_id(16)
	var legendary_chest_tiles = get_used_cells_by_id(18)
	var barrel_tiles = get_used_cells_by_id(8)
	var torch_tiles =  get_used_cells_by_id(15)
	#var grave_tiles = get_used_cells_by_id(9)
	
	tiles_instancing(rare_chest_tiles, rare_chest_scene)
	tiles_instancing(epic_chest_tiles, epic_chest_scene)
	tiles_instancing(legendary_chest_tiles, legendary_chest_scene)
	tiles_instancing(barrel_tiles, barrel_scene)
	tiles_instancing(torch_tiles, torch_light_scene)
	#tiles_instancing(grave_tiles, grave_scene)
	
func tiles_instancing(tile_array, tile_scene):
	for tile in tile_array:
		var tile_instance = tile_scene.instance()
		tile_instance.position = map_to_world(tile)
		tile_instance.tile = tile
		add_child(tile_instance)
