extends Node2D
export(NodePath) var background
export(NodePath) var foreground

var grid=[]
var roomWidth = 150
var roomHeight = 150
onready var player = $Player


var rooms = []

class Room:
	var x1 
	var x2
	var y1 
	var y2 
	var center
	
	func _init(x, y, width, height):
		x1 = x
		y1 = y 
		x2 = x + width
		y2 = y + height
		center = Vector2(floor((x1+x2)/2), floor((y1+y2)/2))
	
	func intersects(room:Room):
		return (x1 <= room.x2 && x2 >= room.x1 &&
			y1 <= room.y2 && room.y2 >= room.y1)

	
class RoomSorter:
	static func sort_ascending(a, b):
		if a.center.x < b.center.x:
			return true
		return false
		
		
enum gridSpace {floor_, wall, ceiling, column, torch, table, pipe, door}

func _ready():
	Utils.enemies_count = 0
	Utils.area_dark = true
	background = get_node(background)
	foreground = get_node(foreground)
	randomize()
	for x in range(150):
		grid.append([])
		grid[x]=[]
		for y in range(150):
			grid[x].append([])
			grid[x][y]=2
			
	Setup()
	



func Setup():


	var spawnPos = Vector2(20,20)
	CreateFloors()
	
func CreateFloors():
		var rng = RandomNumberGenerator.new()
		var iterations = 0
		while (rooms.size() < 7 and iterations < 40):
			var x = rng.randi_range(21, 110)
			var y = rng.randi_range(21, 110)
			var width = randi()%10 + 10
			var height = randi()%10 + 10 
			
			var newRoom = Room.new(x, y, width, height)

			var failed = false
			for i in rooms.size():
				var otherRoom = rooms[i]
				if newRoom.intersects(otherRoom):
					failed = true
					break
				
			if (!failed):
				generate_room(newRoom.x1, newRoom.y1, newRoom.x2, newRoom.y2)
				var new_center = newRoom.center
				rooms.append(newRoom)
			iterations+=1
		rooms.sort_custom(RoomSorter, "sort_ascending")
		for counter in range(rooms.size()-1):
					var old_center = rooms[counter].center
					var new_center = rooms[counter+1].center
					if randi()%2 == 0:
						h_corridor(old_center.x, new_center.x, old_center.y)
						v_corridor(old_center.y, new_center.y, new_center.x)
					else:
						v_corridor(old_center.y, new_center.y, old_center.x)
						h_corridor(old_center.x, new_center.x, new_center.y)



		SpawnBackground()
	
func SpawnBackground():
		for x in range (0, 150):
			for y in range (0, 150):
				match(grid[x][y]):
					gridSpace.floor_:
						background.set_cell(x, y, 1, false, false, false, Vector2(randi()%4,randi()%3))
					gridSpace.wall:
						background.set_cell(x, y, 0, false, false, false, Vector2(randi()%2,randi()%3))
					gridSpace.ceiling:
						foreground.set_cell(x, y, 1)
					gridSpace.column:
						foreground.set_cell(x, y, 0)
		SpawnSingleTiles()
		
func SpawnSingleTiles():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for x in range (0, 100):
			for y in range (0, 100):
				if grid[x][y] == gridSpace.ceiling:
					if (grid[x-1][y]==gridSpace.floor_ and grid[x][y+1]==gridSpace.floor_ and grid[x+1][y+1]==gridSpace.floor_) or (grid[x+1][y]==gridSpace.floor_ and grid[x][y+1]==gridSpace.floor_ and grid[x-1][y+1]==gridSpace.floor_):
						grid[x][y+1] = gridSpace.door
				if (grid[x][y] == gridSpace.ceiling  and grid[x-1][y] == gridSpace.floor_):
					if randi()%15 == 0:
						foreground.set_cell(x-1, y, 5, false, false, false, Vector2(2,0))
				if (grid[x][y] == gridSpace.ceiling  and grid[x+1][y] == gridSpace.floor_):
					if randi()%15 == 0:
						foreground.set_cell(x+1, y, 5, false, false, false, Vector2(0,0))
				if (grid[x][y] == gridSpace.wall and grid[x][y-1] == gridSpace.wall and grid[x][y+1] == gridSpace.wall):
					if randi()%10 == 0:
						foreground.set_cell(x, y, 5, false, false, false, Vector2(1,0))
					
						
						
	for i in range(rooms.size()):
		var point_1 = rng.randi_range(rooms[i].x1, rooms[i].x2-1)
		var point_2 = rng.randi_range(rooms[i].x1, rooms[i].x2-1)
		var point_y = rng.randi_range(rooms[i].y1+4, rooms[i].y2-1)
		var point_3 = rng.randi_range(rooms[i].y1+4, point_y)
		var point_4 = rng.randi_range(point_y, rooms[i].y2-1)
		var point_x = rng.randi_range(min(point_1, point_2)+1, max(point_1, point_2)-1)
		var table_spawned = false
		for x in range(min(point_1, point_2), max(point_1, point_2)):
			grid[x][point_y] = gridSpace.pipe
		for y in range(min(point_3, point_4), max(point_3, point_4)):
			grid[point_x][y] = gridSpace.pipe
		for x in range(rooms[i].x1, rooms[i].x2-2):
			for y in range(rooms[i].y1+4, rooms[i].y2-1):
				if randi()%100 == 0 and !table_spawned:
					grid[x][y] = gridSpace.table
					table_spawned = true
	for x in range (0, 150):
			for y in range (0, 150):
				match(grid[x][y]):
					gridSpace.table:
						foreground.set_cell(x, y, 3)
					gridSpace.door:
						foreground.set_cell(x, y, 2)
					gridSpace.pipe:
						foreground.set_cell(x, y, 4)
						
	foreground.update_bitmask_region()
	foreground.place_tile_scenes()
	player.position = background.map_to_world(rooms[0].center)
	Utils.enemies_count = 1
	#Utils.spawn_enemy("MonsterBlood", Vector2(0,0))
	
func RandomDirection():
	return Utils.random_choice([Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT])
	
func generate_room(x, y, x_, y_):
		
	for i in range(x, x_-1): 
		grid[i][y+1] = gridSpace.wall
		grid[i][y+2] = gridSpace.wall
		grid[i][y+3] = gridSpace.wall
		for j in range (y+4, y_):
			grid[i][j] = gridSpace.floor_
	for i in range (x, x_-1, 2):
		grid[i][y+1] = gridSpace.column
			
func v_corridor(y1, y2, x):
	for i in range(min(y1, y2), max(y1,y2)+2):
		grid[x][i] = gridSpace.floor_
		grid[x+1][i] = gridSpace.floor_

func h_corridor(x1, x2, y):
	for i in range(min(x1, x2), max(x1,x2)+2):
		grid[i][y] = gridSpace.floor_
		grid[i][y+1] = gridSpace.floor_
		
