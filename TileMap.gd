extends TileMap

const WIDTH = 128
const HEIGHT = 64
var grid: Array

func tick() -> void:
	grid = update_grid()
	update_tilemap()

func generate_grid() -> Array:
	var result = []
	for y in range(HEIGHT):
		var row = []
		for x in range(WIDTH):
			row.append(0)
		result.append(row)
	return result

func generate_random_grid():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = []
	for y in range(HEIGHT):
		var row = []
		for x in range(WIDTH):
			var my_random_number = int(rng.randf_range(0, 2))
			row.append(my_random_number)
		result.append(row)
	return result

func update_tilemap() -> void:
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = grid[y][x]
			set_cell(x, y, cell)

func count_neighbors(neighbors) -> int:
	var result = 0
	for i in neighbors:
		if i == 1:
			result += 1
	return result

func update_grid() -> Array:
	var copied_grid = grid.duplicate(true)
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell_status = copied_grid[y][x]
			var neighbors = get_neighbors(x, y)
			var neighbor_count = count_neighbors(neighbors)
			if cell_status == 0:
				if neighbor_count == 3:
					copied_grid[y][x] = 1
			elif cell_status == 1:
				if neighbor_count <= 1:
					copied_grid[y][x] = 0
				elif neighbor_count >= 4:
					copied_grid[y][x] = 0
	return copied_grid

func get_neighbors(x, y):
	var result = []
	result.append(get_cell(x-1, y-1))
	result.append(get_cell(x, y-1))
	result.append(get_cell(x+1, y-1))
	result.append(get_cell(x-1, y))
	result.append(get_cell(x+1, y))
	result.append(get_cell(x-1, y+1))
	result.append(get_cell(x, y+1))
	result.append(get_cell(x+1, y+1))
	return result

func setup_random_grid() -> void:
	grid = generate_random_grid()
	update_tilemap()

func setup_blank_grid() -> void:
	grid = generate_grid()
	update_tilemap()

func add_10_cell_row() -> void:
	var x = int(WIDTH / 2)
	var y = int(HEIGHT / 2)
	grid[y][x-5] = 1
	grid[y][x-4] = 1
	grid[y][x-3] = 1
	grid[y][x-2] = 1
	grid[y][x-1] = 1
	grid[y][x] = 1
	grid[y][x+1] = 1
	grid[y][x+2] = 1
	grid[y][x+3] = 1
	grid[y][x+4] = 1

func add_slider() -> void:
	var x = int(WIDTH / 2)
	var y = int(HEIGHT / 2)
	grid[y][x] = 1
	grid[y][x+1] = 1
	grid[y][x+2] = 1
	grid[y-1][x+2] = 1
	grid[y-2][x+1] = 1

func add_small_exploder() -> void:
	var x = int(WIDTH / 2)
	var y = int(HEIGHT / 2)
	grid[y][x] = 1
	grid[y][x+1] = 1
	grid[y][x+2] = 1
	grid[y-1][x+1] = 1
	grid[y+1][x] = 1
	grid[y+1][x+2] = 1
	grid[y+2][x+1] = 1

func add_exploder() -> void:
	var x = int(WIDTH / 2)
	var y = int(HEIGHT / 2)
	grid[y][x] = 1
	grid[y+1][x] = 1
	grid[y+2][x] = 1
	grid[y+3][x] = 1
	grid[y+4][x] = 1
	grid[y][x+4] = 1
	grid[y+1][x+4] = 1
	grid[y+2][x+4] = 1
	grid[y+3][x+4] = 1
	grid[y+4][x+4] = 1
	grid[y][x+2] = 1
	grid[y+4][x+2] = 1

func _ready() -> void:
	grid = generate_grid()
	update_tilemap()
