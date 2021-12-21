extends YSort

export(NodePath) var background_surface
export(NodePath) var background
export(NodePath) var foreground

var grid = []

enum gridSpace {floor_, wall, ceiling, column, torch}

func _ready():
	background_surface = get_node(background_surface)
	background = get_node(background)
	foreground = get_node(foreground)
	for x in range(100):
		grid.append([])
		grid[x]=[]
		for y in range(100):
			grid[x].append([])
			grid[x][y]=2
	SpawnBackground()
			
func SpawnBackground():
		for x in range (0, 100):
			for y in range (0, 100):
				match(grid[x][y]):
					gridSpace.floor_:
						background.set_cell(x, y, 0, false, false, false, Vector2(randi()%4,randi()%3))
					gridSpace.wall:
						background.set_cell(x, y, 3)
					gridSpace.ceiling:
						background.set_cell(x, y, 1)
					gridSpace.column:
						foreground.set_cell(x, y, 0)
