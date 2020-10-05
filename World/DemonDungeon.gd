extends Node2D
export(NodePath) var background
export(NodePath) var foreground

var grid=[]
var grid_ruins=[]
var roomWidth = 100
var roomHeight = 100
var boxSize = 11
var box_count = 0

var walkers = []
var chanceWalkerChangeDir = 50
var chanceWalkerSpawn = 5
var chanceWalkerDestroy = 5
var maxWalkers = 10
var percentToFill = 0.5

class Walker: 
	var pos: Vector2
	var dir: Vector2
	
	
enum gridSpace {floor_, wall, ceiling, column}

func _ready():
	Utils.area_dark = true
	background = get_node(background)
	foreground = get_node(foreground)
	randomize()
	for x in range(100):
		grid.append([])
		grid[x]=[]
		for y in range(100):
			grid[x].append([])
			grid[x][y]=-1
			
	for x in range(roomWidth):
		grid_ruins.append([])
		grid_ruins[x]=[]
		for y in range(roomHeight):
			grid_ruins[x].append([])
			grid_ruins[x][y]=-1
	#Setup()
	



func Setup():
	var newWalker = Walker.new()
	newWalker.dir = RandomDirection()
	var spawnPos = Vector2(20,20)
	newWalker.pos = spawnPos
	walkers.append(newWalker)
	CreateFloors()
	
func CreateFloors():
		var iterations = 0
		while (iterations < 100000):
			
			for x in range (0, walkers.size()):
				var myWalker = walkers[x]
				grid_ruins[myWalker.pos.x] [myWalker.pos.y] = gridSpace.floor_
				if (myWalker.dir == Vector2.DOWN or myWalker.dir == Vector2.UP):
					box_count+=1
					for i in range (boxSize):
						for j in range (boxSize):
							grid_ruins[myWalker.pos.x+i] [myWalker.pos.y+j] = gridSpace.floor_
				if (myWalker.dir == Vector2.LEFT or myWalker.dir == Vector2.RIGHT):
					box_count+=1
					for i in range (boxSize):
						for j in range (boxSize):
							grid_ruins[myWalker.pos.x+i] [myWalker.pos.y+j] = gridSpace.floor_
				
			
			var numberChecks = walkers.size()
			for i in range (0, numberChecks):

				if (randi()%100 < chanceWalkerDestroy and walkers.size() > 1):
					walkers.remove(i)
					break
				
			for i in range (0, walkers.size()):
				if (randi()%100  < chanceWalkerChangeDir):
					var thisWalker = walkers[i];
					thisWalker.dir = RandomDirection();
					walkers[i] = thisWalker;
				
			

			numberChecks = walkers.size(); 
			for i in range (0, numberChecks):
				if (randi()%100  < chanceWalkerSpawn and walkers.size() < maxWalkers):
					var newWalker = Walker.new()
					newWalker.dir = RandomDirection()
					newWalker.pos = walkers[i].pos
					walkers.append(newWalker)
				
			for i in range (0, walkers.size()):
				var thisWalker = walkers[i]
				thisWalker.pos += thisWalker.dir * Vector2(boxSize,boxSize)
				walkers[i] = thisWalker

			for i in range (0, walkers.size()):
				var thisWalker = walkers[i];

				thisWalker.pos.x = clamp(thisWalker.pos.x, 1, roomWidth-2)
				thisWalker.pos.y = clamp(thisWalker.pos.y, 1, roomHeight-2)
				walkers[i] = thisWalker

			if (box_count > 11):
				break
			iterations+=1
		walkers.clear()

		CreateWalls()
		
func CreateWalls():
		for x in range (0, roomWidth-1):
			for y in range (0, roomHeight-1):
				if (grid_ruins[x][y] == gridSpace.floor_):
					
					if (grid_ruins[x][y+1] == -1):
						grid_ruins[x][y] = gridSpace.ceiling
						grid_ruins[x][y-1] = gridSpace.ceiling
					if (grid_ruins[x+1][y] == -1):
						grid_ruins[x][y] = gridSpace.ceiling
						grid_ruins[x-1][y] = gridSpace.ceiling
					if (grid_ruins[x-1][y] == -1):
						grid_ruins[x][y] = gridSpace.ceiling
						grid_ruins[x+1][y] = gridSpace.ceiling
		for x in range (0, roomWidth-1):
			for y in range (0, roomHeight-1):
				if (grid_ruins[x][y] == gridSpace.floor_):
					if (grid_ruins[x][y-1] == -1):
						grid_ruins[x][y+5] = gridSpace.wall
						grid_ruins[x][y+4] = gridSpace.wall
						grid_ruins[x][y+3] = gridSpace.wall
						grid_ruins[x][y+2] = gridSpace.ceiling
						grid_ruins[x][y+1] = gridSpace.ceiling
						grid_ruins[x][y] = gridSpace.ceiling

	
		Offset()

func Offset():
	for x in range (roomWidth):
		for y in range (roomHeight):
				grid[x][y]=grid_ruins[x][y]
	SpawnBackground()
	
func SpawnBackground():
		for x in range (0, 100):
			for y in range (0, 100):
				match(grid[x][y]):
					gridSpace.floor_:
						background.set_cell(x, y, 2)
					gridSpace.wall:
						background.set_cell(x, y, 0)
					gridSpace.ceiling:
						foreground.set_cell(x, y, 1)
					-1:
						pass
						

		foreground.update_bitmask_region()
	
func RandomDirection():
	return Utils.random_choice([Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT])




