extends Node2D

var foreground
var background
var end_point
var path = []
var prev_path = []
var max_index
var min_index
var body_points = []

var deathTimer
		
		## Variables to be set when the node is ready


# Reference to a new AStar navigation grid node
onready var astar = AStar.new()

# Used to find the centre of a tile
onready var half_cell_size = 7

# All tiles that can be used for pathfinding
var traversable_tiles 

# The bounds of the rectangle containing all used tiles on this tilemap
var used_rect




	# This would hide the navigation_map upon loading, but we'll keep
	# it commented for this demo - uncomment for your game, most likely
	# visible = false

	# Add all tiles to the navigation grid


## Private functions


# Adds tiles to the A* grid but does not connect them
# ie. They will exist on the grid, but you cannot find a path yet
func _add_traversable_tiles(traversable_tiles):

	# Loop over all tiles
	for tile in traversable_tiles:

		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		# Add the tile to the AStar navigation
		# NOTE: We use Vector3 as AStar is, internally, 3D. We just don't use Z.
		astar.add_point(id, Vector3(tile.x, tile.y, 0))


# Connects all tiles on the A* grid with their surrounding tiles
func _connect_traversable_tiles(traversable_tiles):

	# Loop over all tiles
	for tile in traversable_tiles:

		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		# Loops used to search around player (range(3) returns 0, 1, and 2)
		for x in range(3):
			for y in range(3):

				# Determines target, converting range variable to -1, 0, and 1
				var target = tile + Vector2(x - 1, y - 1)

				# Determines target ID
				var target_id = _get_id_for_point(target)

				# Do not connect if point is same or point does not exist on astar
				if tile == target or not astar.has_point(target_id):
					continue

				# Connect points
				astar.connect_points(id, target_id, true)


# Determines a unique ID for a given point on the map
func _get_id_for_point(point):

	# Offset position of tile with the bounds of the tilemap
	# This prevents ID's of less than 0, if points are behind (0, 0)
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y

	# Returns the unique ID for the point on the map
	return x + y * used_rect.size.x


## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func simple_path(start, end):
	# Convert positions to cell coordinates
	var start_tile = background.world_to_map(start)
	var end_tile = background.world_to_map(end)


	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)

	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null

	# Otherwise, find the map
	var path_map = astar.get_point_path(start_id, end_id)
	# Convert Vector3 array (remember, AStar is 3D) to real world points
	var path_world = []
	for point in path_map:
		#var point_world = background.map_to_world(Vector2(point.x, point.y)) #+ half_cell_size
		path_world.append(Vector2(point.x, point.y))
		#path_map[point] = Vector2(path_map[point].x, path_map[point].y)
	return path_world

	
# Called when the node enters the scene tree for the first time.
func _ready():
	var segments = 10
	foreground = get_node("/root/World/ForegroundTiles")
	background = get_node("/root/World/BackgroundTiles")
	for x in range (0, 100):
		for y in range (0, 100):
				if background.get_cell(x, y) == 1 and segments > 0:
					foreground.set_cell(x, y, 6)
					body_points.push_front(Vector2(x,y))
					segments -= 1
	traversable_tiles = background.get_used_cells_by_id(1)
	used_rect = foreground.get_used_rect()
	
	_add_traversable_tiles(traversable_tiles)


	_connect_traversable_tiles(traversable_tiles)
			
	var segment_counter = 10

				
	deathTimer = Timer.new()
	deathTimer.set_wait_time(0.5)
	deathTimer.connect("timeout", self, "update")
	add_child(deathTimer)
	deathTimer.start()
	
func update():

	max_index = 0
	min_index = 0
	end_point = get_parent().get_node("/root/World/Player").position
	#body_points = foreground.get_used_cells_by_id(6)
	#body_points = quicksort(body_points)
	prev_path = path
	path = simple_path(foreground.map_to_world(body_points[0]), end_point)

	if path == null:
		path = prev_path
	path.remove(0)
	move()

func quicksort(nums):
	if nums.size() <= 1: 
		return nums
	else:
		var q = nums[nums.size()/2]
		var s_nums = []
		var m_nums = []
		var e_nums = []
		for n in nums:
			if n < q:
				s_nums.append(n)
			elif n > q:
				m_nums.append(n)
			else:
				e_nums.append(n)
		return quicksort(s_nums) + e_nums + quicksort(m_nums)

func move():
	#while body_points.size()>4: 
		#body_points.remove(body_points.size()-1)
	foreground.set_cellv((path[0]), 6)
	body_points.push_front(Vector2(path[0]))
	foreground.set_cellv(body_points[-1], -1)
	body_points.pop_back()

	#if (path[0].x!=path[1].x):
		#if background.get_cellv(path[0]+Vector2(0,1))==1:
			#foreground.set_cellv(path[0]+Vector2(0,1), 6)
		#if background.get_cellv(path[0]-Vector2(0,1))==1:
			#foreground.set_cellv(path[0]-Vector2(0,1), 6)
	#elif (path[0].y!=path[1].y):
		#if background.get_cellv(path[0]+Vector2(1,0))==1:
			#foreground.set_cellv(path[0]+Vector2(1,0), 6)
		#if background.get_cellv(path[0]-Vector2(1,0))==1:
			#foreground.set_cellv(path[0]-Vector2(1,0), 6)
		
		
			

