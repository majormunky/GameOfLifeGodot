extends Node2D

enum {
	STOPPED,
	PLAYING
}

onready var tilemap = $TileMap
onready var start_button = $Control/ColorRect/StartButton
onready var timer = $Timer
onready var speed_label = $Control/ColorRect/SpeedLabel

var rng: RandomNumberGenerator
var grid = null
var state = STOPPED

const ALIVE = 1
const DEAD = 0
const WIDTH = 128
const HEIGHT = 64

func generate_random_grid():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = []
	for y in range(HEIGHT):
		var row = []
		for x in range(WIDTH):
			var my_random_number = int(rng.randf_range(0, 2))
			row.append(my_random_number)
		result.append(row)
	return result

func generate_grid() -> Array:
	var result = []
	for y in range(HEIGHT):
		var row = []
		for x in range(WIDTH):
			row.append(0)
		result.append(row)
	return result

func update_tilemap() -> void:
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = grid[y][x]
			tilemap.set_cell(x, y, cell)

func _ready() -> void:
	grid = generate_random_grid()
	
	grid[4][2] = 1
	grid[4][3] = 1
	grid[4][4] = 1
	grid[3][4] = 1
	grid[2][3] = 1
	
	update_tilemap()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tick"):
		tick()

func get_neighbors(x, y):
	var result = []
	result.append(tilemap.get_cell(x-1, y-1))
	result.append(tilemap.get_cell(x, y-1))
	result.append(tilemap.get_cell(x+1, y-1))
	result.append(tilemap.get_cell(x-1, y))
	result.append(tilemap.get_cell(x+1, y))
	result.append(tilemap.get_cell(x-1, y+1))
	result.append(tilemap.get_cell(x, y+1))
	result.append(tilemap.get_cell(x+1, y+1))
	return result

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
			# prints("x:", x, "y:", y, "status:", cell_status, "nc:", neighbor_count)
			if cell_status == 0:
				if neighbor_count == 3:
					copied_grid[y][x] = 1
			elif cell_status == 1:
				if neighbor_count <= 1:
					copied_grid[y][x] = 0
				elif neighbor_count >= 4:
					copied_grid[y][x] = 0
	return copied_grid

func tick() -> void:
	grid = update_grid()
	update_tilemap()

func _on_Timer_timeout() -> void:
	if state == PLAYING:
		tick()


func _on_StartButton_button_up() -> void:
	if state == STOPPED:
		state = PLAYING
		start_button.text = "Stop"
	else:
		state = STOPPED
		start_button.text = "Start"

func _on_SpeedSlider_value_changed(value: float) -> void:
	timer.wait_time = value
	speed_label.text = str(value) + " seconds"

func _on_TickButton_button_up() -> void:
	tick()
