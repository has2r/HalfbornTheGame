extends Node2D
export(NodePath) var background
export(NodePath) var foreground
var explosion_effect = preload("res://Dusts/Explosion.tscn")
var explosion_effect_1 = preload("res://Dusts/BarrelBroke.tscn")
var grid=[] 
var grid_ruins=[] 
var chestSpawned = false
var box_number = 1


func _ready():
	randomize()
	if randi()%4 == 0:
		$CanvasModulate.color = Color(0.54, 0.69, 1, 1)
	else:
		$CanvasModulate.color = Color(1, 1, 1, 1)
	add_child(explosion_effect.instance())
	add_child(explosion_effect_1.instance())
	Utils.area_dark = false
	Utils.enemies_count = 0
	background = get_node(background)
	foreground = get_node(foreground)

	for x in range(140):
		grid.append([])
		grid[x]=[]
		for y in range(140):
			grid[x].append([])
			grid[x][y]=0
			
	for x in range(20, 120):
		for y in range (20, 120):
			grid[x][y] = gridSpace.earth_grass
	Setup(box_number)
		
	
	
func _process(delta):
	Engine.set_target_fps(Engine.get_iterations_per_second())
class Walker: 
	var pos: Vector2
	var dir: Vector2
	
enum gridSpace {empty_, floor_, wall_ground, wall_middle_part, shadow, earth_ground, earth_grass, stone_grass, barrel, grave, chest_rare, chest_epic, chest_legendary, tree, dry_tree}

var roomHeight
var roomWidth
var ruins_offset_x = 3
var ruins_offset_y = 3

var walkers = []
var chanceWalkerChangeDir = 50
var chanceWalkerSpawn = 5
var chanceWalkerDestroy = 5
var maxWalkers = 10
var percentToFill = 20

	
func Setup(box_num):
	match box_num:
		1:
			ruins_offset_x = 23
			ruins_offset_y = randi()%3 + 23
			CreateRuins()
		2:
			ruins_offset_x = 56
			ruins_offset_y = randi()%3 + 23
			CreateRuins()
		3:
			ruins_offset_x = 89
			ruins_offset_y = randi()%3+ 23
			CreateRuins()
		4:
			ruins_offset_x = 38
			ruins_offset_y = randi()%3 + 70
			CreateRuins()
		5:
			ruins_offset_x = 70
			ruins_offset_y = randi()%3 + 70
			CreateRuins()
		6:
			CreateGround()

		
func CreateRuins():
	grid_ruins=[]
	#roomHeight = clamp(randi()% 20 + 10, 10, 20)
	#roomWidth = clamp(randi()% 20 + 10, 10, 20)
	roomHeight = 25
	roomWidth = 25
	percentToFill = min(roomHeight, roomWidth)/3
	for x in range(roomWidth):
		grid_ruins.append([])
		grid_ruins[x]=[]
		for y in range(roomHeight):
			grid_ruins[x].append([])
			grid_ruins[x][y]=0
	
	
	for x in range(0, roomWidth):
			for y in range (0, roomHeight):
				grid_ruins[x][y] = gridSpace.empty_
				
	var newWalker = Walker.new()
	newWalker.dir = RandomDirection()
	var spawnPos = Vector2(roomWidth/2, roomHeight/2)
	newWalker.pos = spawnPos
	walkers.append(newWalker)
	CreateFloors()
	

func CreateFloors():
		var iterations = 0
		while (iterations < 100000):
			
			#placing floor tiles
			for x in range (0, walkers.size()):
				var myWalker = walkers[x]
				grid_ruins[myWalker.pos.x] [myWalker.pos.y] = gridSpace.floor_
				if (myWalker.dir == Vector2.DOWN or myWalker.dir == Vector2.UP):
					grid_ruins[myWalker.pos.x+1] [myWalker.pos.y] = gridSpace.floor_
				if (myWalker.dir == Vector2.LEFT or myWalker.dir == Vector2.RIGHT):
					grid_ruins[myWalker.pos.x] [myWalker.pos.y+1] = gridSpace.floor_
				
			
			var numberChecks = walkers.size()
			for i in range (0, numberChecks):

			#destroying walkers
				if (randi()%100 < chanceWalkerDestroy and walkers.size() > 1):
					walkers.remove(i)
					break
				
			#changing walkers direction
			for i in range (0, walkers.size()): 
				if (randi()%100  < chanceWalkerChangeDir):
					var thisWalker = walkers[i]
					thisWalker.dir = RandomDirection()
					walkers[i] = thisWalker;
				
			
			#creating new walkers
			numberChecks = walkers.size();
			for i in range (0, numberChecks):
				if (randi()%100  < chanceWalkerSpawn and walkers.size() < maxWalkers):
					var newWalker = Walker.new()
					newWalker.dir = RandomDirection()
					newWalker.pos = walkers[i].pos
					walkers.append(newWalker)
			
			#moving walkers
			for i in range (0, walkers.size()):
				var thisWalker = walkers[i]
				thisWalker.pos += thisWalker.dir
				walkers[i] = thisWalker

			#limiting walkers movement
			for i in range (0, walkers.size()):
				var thisWalker = walkers[i];

				thisWalker.pos.x = clamp(thisWalker.pos.x, 3, roomWidth-3)
				thisWalker.pos.y = clamp(thisWalker.pos.y, 3, roomHeight-3)
				walkers[i] = thisWalker

			if (NumberOfFloors() / grid_ruins.size() > percentToFill):
				break
			iterations+=1
		walkers.clear()
		var rand_wall = RandomDirection()
		match rand_wall: #creating exit from ruins
			Vector2.UP:
				for i in range(0, roomHeight/2):
					grid_ruins[roomWidth/2-1][i] = gridSpace.floor_
					grid_ruins[roomWidth/2][i] = gridSpace.floor_
					grid_ruins[roomWidth/2+1][i] = gridSpace.floor_
			Vector2.DOWN:
				for i in range(roomHeight/2, roomHeight):
					grid_ruins[roomWidth/2-1][i] = gridSpace.floor_
					grid_ruins[roomWidth/2][i] = gridSpace.floor_
					grid_ruins[roomWidth/2+1][i] = gridSpace.floor_
			Vector2.RIGHT:
				for i in range(roomWidth/2, roomWidth):
					grid_ruins[i][roomHeight/2-1] = gridSpace.floor_
					grid_ruins[i][roomHeight/2] = gridSpace.floor_
					grid_ruins[i][roomHeight/2+1] = gridSpace.floor_
			Vector2.LEFT:
				for i in range(0, roomWidth/2):
					grid_ruins[i][roomHeight/2-1] = gridSpace.floor_
					grid_ruins[i][roomHeight/2] = gridSpace.floor_
					grid_ruins[i][roomHeight/2+1] = gridSpace.floor_
		CreateWalls()

func CreateWalls():
		
		#destroying single walls
		for x in range (1, roomWidth-1):
			for y in range (1, roomHeight-1):
				if (grid_ruins[x][y] == gridSpace.empty_ and grid_ruins[x][y+1]==gridSpace.floor_ and grid_ruins[x][y-1]==gridSpace.floor_ and
														grid_ruins[x+1][y]==gridSpace.floor_ and grid_ruins[x-1][y]==gridSpace.floor_):
					grid_ruins[x][y] = gridSpace.floor_
		#destroying walls that are too close to each other 
		for x in range (2, roomWidth-1):
			for y in range (2, roomHeight-1):
				if (grid_ruins[x][y] == gridSpace.empty_ and grid_ruins[x][y-1]==gridSpace.floor_ and grid_ruins[x][y-2]==gridSpace.empty_):
					grid_ruins[x][y] = gridSpace.floor_
					
					
					
		for x in range (0, roomWidth-1):
			for y in range (0, roomHeight-1):
				
				if (grid_ruins[x][y] == gridSpace.empty_ and grid_ruins[x][y+1] == gridSpace.floor_):
					grid_ruins[x][y-1] = gridSpace.empty_
					grid_ruins[x][y] = gridSpace.wall_middle_part
					grid_ruins[x][y+1] = gridSpace.wall_ground
					grid_ruins[x][y+2] = gridSpace.shadow
	
		Offset()

func Offset():
	for x in range (roomWidth):
		for y in range (roomHeight):
			grid[x+ruins_offset_x][y+ruins_offset_y]=grid_ruins[x][y]
	box_number+=1
	
	Setup(box_number)
	
func CreateGround():
	for x in range (3,136):
		for y in range (3,136):
			if (grid[x][y] == gridSpace.earth_grass and randi()%25 == 0):
				var rand_x = randi()%3 + 2
				var rand_y = randi()%3 + 2
				if (grid[x+rand_x][y+rand_y] == gridSpace.earth_grass):
					for i in range (x, x + rand_x):
						for j in range (y, y + rand_y):
							grid[i][j] = gridSpace.earth_ground
	SpawnBackground()
					
func SpawnBackground():
		for x in range (0, 140):
			for y in range (0, 140):
				match(grid[x][y]):
					gridSpace.empty_:
						foreground.set_cell(x, y, 5)
					gridSpace.floor_:
						background.set_cell(x, y, 27, false, false, false, Vector2(randi()%2,randi()%2))
					gridSpace.wall_ground:
						background.set_cell(x, y, 26, false, false, false, Vector2(randi()%2,0))
					gridSpace.wall_middle_part:
						foreground.set_cell(x, y, 2, false, false, false, Vector2(randi()%3,0))
					gridSpace.shadow:
						background.set_cell(x, y, 22)
					gridSpace.earth_ground:
						background.set_cell(x, y, 25, false, false, false, Vector2(randi()%2,randi()%2))
					gridSpace.earth_grass:
						background.set_cell(x, y, 23)
		background.update_bitmask_region()
		foreground.update_bitmask_region()
		SpawnSingleTiles()
		
	
func SpawnSingleTiles():
	for x in range (3,136):
		for y in range (3,136):
			if (grid[x][y] == gridSpace.earth_ground and randi()%50 == 0):
				grid[x][y] = gridSpace.barrel
				if (grid[x+1][y] == gridSpace.earth_ground and randi()%5 == 0):
					grid[x+1][y] = gridSpace.barrel
				if (grid[x-1][y] == gridSpace.earth_ground and randi()%5 == 0):
					grid[x-1][y] = gridSpace.barrel
				if (grid[x][y+1] == gridSpace.earth_ground and randi()%5 == 0):
					grid[x][y+1] = gridSpace.barrel
				if (grid[x][y-1] == gridSpace.earth_ground and randi()%5 == 0):
					grid[x][y-1] = gridSpace.barrel
					
			if (grid[x][y] == gridSpace.floor_ and randi()%100 == 0):
				grid[x][y] = gridSpace.grave
				if (grid[x+1][y] == gridSpace.floor_ and randi()%5 == 0):
					grid[x+1][y] = gridSpace.grave
				if (grid[x-1][y] == gridSpace.floor_ and randi()%5 == 0):
					grid[x-1][y] = gridSpace.grave
				if (grid[x][y+1] == gridSpace.floor_ and randi()%5 == 0):
					grid[x][y+1] = gridSpace.grave
				if (grid[x][y-1] == gridSpace.floor_ and randi()%5 == 0):
					grid[x][y-1] = gridSpace.grave

			if (grid[x][y] == gridSpace.floor_ and grid[x][y+1] == gridSpace.floor_ 
			and randi()%100 == 0 and !chestSpawned):
				var chest_chance = randi()%10
				if (chest_chance!=0):
					if (chest_chance > 3):
						grid[x][y] = gridSpace.chest_epic
					else:
						grid[x][y] = gridSpace.chest_rare
				else:
					  grid[x][y] = gridSpace.chest_legendary 
				chestSpawned = true
	for x in range (0,130):
		for y in range (0,130):
			if (grid[x+1][y+3] == gridSpace.earth_ground and (grid[x][y] == gridSpace.earth_ground or grid[x][y] == gridSpace.earth_grass) 
			and (grid[x+1][y+2] == gridSpace.earth_ground or grid[x+1][y+2] == gridSpace.earth_grass) 
			and (grid[x+2][y+1] == gridSpace.earth_ground or grid[x+2][y+1] == gridSpace.earth_grass) and randi()%25 == 0):
				grid[x][y] = gridSpace.dry_tree
				
			if (grid[x+1][y+3] == gridSpace.earth_grass and (grid[x][y] == gridSpace.earth_ground or grid[x][y] == gridSpace.earth_grass) 
			and (grid[x+1][y+2] == gridSpace.earth_ground or grid[x+1][y+2] == gridSpace.earth_grass) 
			and (grid[x+2][y+1] == gridSpace.earth_ground or grid[x+2][y+1] == gridSpace.earth_grass) and randi()%25 == 0):
				grid[x][y] = gridSpace.tree
				
			if (grid[x][y] == gridSpace.empty_ and grid[x-1][y] !=gridSpace.empty_ and grid[x-1][y] !=gridSpace.wall_middle_part):
				if randi()%15 == 0:
					foreground.set_cell(x-1, y, 15, false, false, false, Vector2(2,0))
			if (grid[x][y] == gridSpace.empty_ and grid[x+1][y] !=gridSpace.empty_ and grid[x+1][y] !=gridSpace.wall_middle_part):
				if randi()%15 == 0:
					foreground.set_cell(x+1, y, 15, false, false, false, Vector2(0,0))
			if (grid[x][y] == gridSpace.wall_middle_part and grid[x][y+1] !=gridSpace.empty_):
				if randi()%15 == 0:
					foreground.set_cell(x, y+1, 15, false, false, false, Vector2(1,0))
		
				
	SpawnForeground()
	
func SpawnForeground():
	for x in range (0, 140):
			for y in range (0, 140):
				match(grid[x][y]):             
					gridSpace.barrel:
						foreground.set_cell(x, y, 8, false, false, false, Vector2(randi()%2,0))
					gridSpace.grave:
						foreground.set_cell(x, y, 9, false, false, false, Vector2(randi()%2,randi()%2))
					gridSpace.chest_rare:
						foreground.set_cell(x, y, 17, false, false, false, Vector2(0,0))
					gridSpace.chest_epic:
						foreground.set_cell(x, y, 16, false, false, false, Vector2(0,0))
					gridSpace.chest_legendary:
						foreground.set_cell(x, y, 18, false, false, false, Vector2(0,0))
					gridSpace.tree:
						foreground.set_cell(x, y, 13, false, false, false, Vector2(randi()%2,0))
					gridSpace.dry_tree:
						foreground.set_cell(x, y, 14, false, false, false, Vector2(randi()%2,0))
	foreground.update_bitmask_region()
	foreground.place_tile_scenes()
	SpawnEnemies()
	
func SpawnEnemies():
	for x in range (3,136):
		for y in range (3,136):
			if (grid[x][y] == gridSpace.earth_ground and randi()%200 == 0):
				Utils.spawn_enemy("BanditWithSword", background.map_to_world(Vector2(x,y)))
			if (grid[x][y] == gridSpace.floor_ and randi()%200 == 0):
				Utils.spawn_enemy("Skeleton", background.map_to_world(Vector2(x,y)))

		
func RandomDirection():
	return Utils.random_choice([Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT])

func NumberOfFloors():
	var count = 0
	for x in range(0, roomWidth):
		for y in range (0, roomHeight-1):
			if (grid_ruins[x][y] == gridSpace.floor_):
				count+=1
	return count
