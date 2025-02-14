extends Node2D

var map_as_array: Array
var settings = MushMashMapSettings.new()
var constants = _MushMash_Constants

enum Direction {Up, Down, Left, Right}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_as_array = sample_map_1()
	draw_cells()

func _input(event):
	if event.is_action_pressed("ui_right"):
		_update_map(Direction.Right)
	if event.is_action_pressed("ui_left"):
		_update_map(Direction.Left)
	if event.is_action_pressed("ui_down"):
		_update_map(Direction.Down)
	if event.is_action_pressed("ui_up"):
		_update_map(Direction.Up)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# _update_inputs()
	
func initialise_random_map():
	map_as_array = []
	var row
	for i in range(settings.height):
		row = []
		for j in range(settings.width):
			row.append(0)
		map_as_array.append(row)
	return map_as_array

func sample_map_1():
	var sample: Array = [
		[0,-1,-1,-1,0],
		[0,0,0,0,0],
		[0,2,2,2,0],
		[0,0,0,0,0],
		[0,1,1,1,0]
		]
	return sample

func draw_cells():
	var uuid	
	for i in range(settings.height):
		for j in range(settings.width):
			if map_as_array[j][i] > 0:
				uuid = _MushMash_Constants.get_cell_uuid(i, j)
				var cell_settings: MushMashCellSettings = MushMashCellSettings.new()
				var cell = preload("res://games/knews/nodes/mushmash/node.mushmash.cell.tscn").instantiate()
				cell.settings = cell_settings
				cell.position = Vector2(150 * i, 150 * j)
				Variables.global[uuid] = cell
				# cell.connect("animation_player_is_ready", _on_animation_player_is_ready(cell))
				# cell.animation_player_is_ready.connect(_on_animation_player_is_ready)
				push_error(get_parent().name)
				$GridOrigin.add_child(cell)
				cell.animation_player.play("Idle")

func _update_map(direction: int):
	var new_map = []
	var new_uuid_reference = {}

	for row in map_as_array:
		new_map.append(row)
	for j in range(settings.height):
		for i in range(settings.width):
			if direction == Direction.Down and j + 1 < settings.height:
				new_map[j+1][i] = 1
				_update_single_cell(i, j, i, j + 1, new_uuid_reference)

			elif direction == Direction.Up and j - 1 >= 0:
				new_map[j-1][i] = 1
				_update_single_cell(i, j, i, j - 1, new_uuid_reference)
				
			elif direction == Direction.Left and i - 1 >= 0:
				new_map[j][i - 1] = 1
				_update_single_cell(i, j, i - 1, j, new_uuid_reference)
				
			elif direction == Direction.Right and i + 1 < settings.width:
				new_map[j][i + 1] = 1
				_update_single_cell(i, j, i + 1, j, new_uuid_reference)
				
	map_as_array = new_map
	_MushMash_Constants.lID_Map_Cells = new_uuid_reference

func _update_single_cell(old_x, old_y, new_x, new_y, new_uuid_reference):
	var uuid
	var cell: MushMashCell
	if map_as_array[old_y][old_x] > 0:
		uuid = _MushMash_Constants.get_cell_uuid(old_x, old_y)
		cell = Variables.global[uuid]
		cell.position = Vector2(150 * new_x, 150 * new_y)
		new_uuid_reference[new_y * _MushMash_Constants.max_nodes + new_x] = uuid

func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell) # .animation_player.play("Idle")
	
