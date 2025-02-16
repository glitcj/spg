extends Node2D


# TODO: This should be used only once to initialise map
var cells_array: Array


var settings = MushMashMapSettings.new()
var uuid_map := {}

var cells_map: Dictionary
enum Direction {Up, Down, Left, Right}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cells_array = sample_map_2()
	
	_initialise_cells_map()
	draw_cells()

func _initialise_uuid_map():
	for j in settings.height:
		for i in settings.width:
			uuid_map[j * settings.height + i] = _MushMash_Constants.get_cell_uuid(i, j)


func _initialise_cells_map():
	var uuid: String
		
	cells_map = CommonFunctions.nulls_2D_map(settings.width, settings.height)
	for j in range(settings.height):
		for i in range(settings.width):
			if cells_array[j][i] == 1:
				uuid = _MushMash_Constants.get_cell_uuid(i, j)
				var cell_settings: MushMashCellSettings = MushMashCellSettings.new()
				cell_settings.uuid = uuid
				cell_settings.x = i
				cell_settings.y = j
				cell_settings.new_x = i
				cell_settings.new_y = j
				var cell = preload("res://games/knews/nodes/mushmash/node.mushmash.cell.tscn").instantiate()
				cell.settings = cell_settings
				cells_map[j][i] = cell

func _get_uuid(x, y):
	return uuid_map[y * settings.height + x]
	

func _input(event):
	if event.is_action_pressed("ui_right"):
		_update_new_positions(Direction.Right)
		_update_map()
	elif event.is_action_pressed("ui_left"):
		_update_new_positions(Direction.Left)
		_update_map()
	elif event.is_action_pressed("ui_down"):
		_update_new_positions(Direction.Down)
		_update_map()
	elif event.is_action_pressed("ui_up"):
		_update_new_positions(Direction.Up)
		_update_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# _update_inputs()
	
func initialise_random_map():
	cells_array = []
	var row
	for i in range(settings.height):
		row = []
		for j in range(settings.width):
			row.append(0)
		cells_array.append(row)
	return cells_array

func sample_map_1():
	var sample: Array = [
		[0,1,1,1,0],
		[0,0,0,0,0],
		[0,1,1,1,0],
		[0,0,0,0,0],
		[0,1,1,1,0]
		]
	return sample


func sample_map_2():
	var sample: Array = [
		[0,1,1,1,1],
		[0,0,0,0,0],
		[0,1,1,1,1],
		[0,0,0,0,0],
		[0,1,1,1,1]
		]
	return sample


func draw_cells():
	var uuid	
	for i in range(settings.height):
		for j in range(settings.width):
			if cells_array[j][i] > 0:
				var cell: MushMashCell = cells_map[j][i]
				cell.position = Vector2(150 * i, 150 * j)
				push_error(get_parent().name)
				$GridOrigin.add_child(cell)
				cell.animation_player.play("Idle")



func _update_map():
	var all_cells = _get_all_cells()
	for cell: MushMashCell in all_cells:
		if cell.settings.new_x != cell.settings.x:
			cell.settings.x = cell.settings.new_x
		if cell.settings.new_y != cell.settings.y:
			cell.settings.y = cell.settings.new_y
		cell.position = Vector2(150 * cell.settings.x, 150 * cell.settings.y)
			
	print("\n\n----- New Maps ------")
	print_cells_map()
	print_uuid_map()	
			

func _update_new_positions(direction: int):
	print("\n\n----- Old Maps ------")
	print_cells_map()
	print_uuid_map()	
	
	# var new_cells_map = CommonFunctions.nulls_2D_map(settings.height, settings.width)
	for j in range(settings.height):
		for i in range(settings.width):
			if cells_map[j][i] == null:
				continue
			if direction == Direction.Down and j + 1 < settings.height:
				_update_single_cell(i, j, i, j + 1)

			elif direction == Direction.Up and j - 1 >= 0:
				_update_single_cell(i, j, i, j - 1)
				
			elif direction == Direction.Left and i - 1 >= 0:
				_update_single_cell(i, j, i - 1, j)
				
			elif direction == Direction.Right and i + 1 < settings.width:
				_update_single_cell(i, j, i + 1, j)

	_resolve_cell_collisions()
	_update_cells_map()
	



func _update_single_cell(old_x, old_y, new_x, new_y):
	var cell: MushMashCell = cells_map[old_y][old_x]
	cell.settings.new_x = new_x
	cell.settings.new_y = new_y
	


	
func _update_cells_map():
	var new_cells_map: Dictionary = CommonFunctions.nulls_2D_map(settings.height, settings.width)
	for cell in _get_all_cells():
		new_cells_map[cell.settings.new_y][cell.settings.new_x] = cell
	cells_map = new_cells_map

func _get_all_cells():
	var all_cells = []
	for j in range(settings.height):
		for i in range(settings.width):
			if cells_map[j][i] != null:
				all_cells.append(cells_map[j][i])
	return all_cells

func _resolve_cell_collisions():
	var all_cells = _get_all_cells()
	
	# var resolved_cells: Array = []
	var remaining_cells: Array
	var collision_detected: bool
	var current_cell: MushMashCell
	var other_cell: MushMashCell
	while true:
		if all_cells == []:
			break
			
		current_cell = all_cells.pop_front()
		collision_detected = false
		
		remaining_cells = []
		while true:
			if all_cells == []:
				break
				
			other_cell = all_cells.pop_front()
			if [current_cell.settings.new_x, current_cell.settings.new_y] == [other_cell.settings.new_x, other_cell.settings.new_y]:
				collision_detected = true
				# other_cell.settings.new_x = other_cell.settings.x
				# other_cell.settings.new_y = other_cell.settings.y
				
			else:
				remaining_cells.append(other_cell)
		
		
		
		if collision_detected:
			current_cell.settings.new_x = current_cell.settings.x
			current_cell.settings.new_y = current_cell.settings.y
		# resolved_cells.append(current_cell)
				
		all_cells = remaining_cells
		


func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell) # .animation_player.play("Idle")
	
func print_cells_map():
	print("Cells Map")
	for j in range(settings.height):
		var line = ""
		for i in range(settings.height):
			var cell: MushMashCell = cells_map[j][i]
			if cell != null:
				line = line + str(cell.settings.x) + "," + str(cell.settings.y) + "   "
			else:
				line = line + "null" + "   "
		print(line)

		
func print_uuid_map(max_uuid_digits: int = 4):
	print("UUID Map")
	for j in range(settings.height):
		var line = ""
		for i in range(settings.height):
			if cells_map[j][i]:
				line = line + cells_map[j][i].settings.uuid.substr(0,max_uuid_digits) + "   "
			else:
				line = line + "null" + "   "
		print(line)
