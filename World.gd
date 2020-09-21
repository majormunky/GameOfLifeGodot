extends Node2D

enum {
	STOPPED,
	PLAYING
}

onready var tilemap = $TileMap
onready var start_button = $Control/ColorRect/StartButton
onready var timer = $Timer
onready var speed_label = $Control/ColorRect/SpeedLabel
onready var item_list = $Control/ColorRect/ItemList

var state = STOPPED
var shapes = [
	"Slider",
	"Small Exploder",
	"Exploder",
	"10 Cell Row",
]

func _ready() -> void:
	for shape in shapes:
		item_list.add_item(shape)

func _unhandled_input(event):
	if Input.is_action_just_released("tick"):
		tick()

func tick() -> void:
	tilemap.tick()

func add_shape(name: String) -> void:
	match name:
		"Slider":
			tilemap.add_slider()
		"Small Exploder":
			tilemap.add_small_exploder()
		"Exploder":
			tilemap.add_exploder()
		"10 Cell Row":
			tilemap.add_10_cell_row()
	tilemap.update_tilemap()

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

func _on_AddShapeButton_button_up() -> void:
	if item_list.is_anything_selected():
		var selected_shape_index = item_list.get_selected_items()[0]
		var selected_shape = shapes[selected_shape_index]
		add_shape(selected_shape)

func _on_RandomButton_button_up() -> void:
	tilemap.setup_random_grid()

func _on_ClearButton_button_up() -> void:
	tilemap.setup_blank_grid()
