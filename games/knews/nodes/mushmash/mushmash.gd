extends Node2D


# TODO: Add MushMash Ready for action animations


# TODO: This should be used only once to initialise map
var cells_map_initialiser: Array
var cells_turn_queue: Array
var current_active_cell: MushMashCell

var settings: MushMashMapSettings = MushMashMapSettings.new()
var uuid_map := {}

var cells_map: Dictionary
enum Direction {Up, Down, Left, Right}

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, EnemyTurn}

var player_cell_is_active := false
var current_turn_state := TurnStates.IdleBeforePlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cells_map_initialiser = sample_map_1()
	
	_initialise_cells_map()
	draw_cells()
	
	# _start_next_turn()
	$ActionTimerNode2D.turn_timer_timeout.connect()


func _on_turn_timer_timeout():
	pass

func _initialise_uuid_map():
	for j in settings.height:
		for i in settings.width:
			uuid_map[j * settings.height + i] = _MushMash_Constants.get_cell_uuid(i, j)


func _initialise_cells_map():
	var uuid: String
	cells_map = CommonFunctions.nulls_2D_map(settings.width, settings.height)
	for j in range(settings.height):
		for i in range(settings.width):
			if cells_map_initialiser[j][i] > 0:
				uuid = _MushMash_Constants.get_cell_uuid(i, j)
				var cell_settings: MushMashCellSettings = MushMashCellSettings.new()
				cell_settings.uuid = uuid
				cell_settings.x = i
				cell_settings.y = j
				cell_settings.new_x = i
				cell_settings.new_y = j
				
				var cell: MushMashCell
				if cells_map_initialiser[j][i] == 1:
					cell_settings.is_movable = false
					cell = settings.mushroom_template.instantiate()
				elif cells_map_initialiser[j][i] == 2:
					cell_settings.is_movable = false
					cell = settings.wall_template.instantiate()
				elif cells_map_initialiser[j][i] == 3:
					cell_settings.is_movable = false
					cell = settings.flower_template.instantiate()

				cell.settings = cell_settings
				cells_map[j][i] = cell
	
	_initialise_cells_turn_queue()
	
func _update_cells_turn_queue():
	cells_turn_queue = _get_all_cells()

func _initialise_cells_turn_queue():
	cells_turn_queue = _get_all_cells()
	
func _start_next_turn():
	current_active_cell = cells_turn_queue.pop_front()
	current_active_cell.animation_player.play("ReadyForAction")
	current_active_cell.settings.is_movable = true
	player_cell_is_active = true
	
	$ActionTimerNode2D/ActionTimer.start()
	await $ActionTimerNode2D.turn_timer_timeout
	if player_cell_is_active:
		_end_current_turn()
	
func _end_current_turn():
	current_active_cell.settings.is_movable = false
	current_active_cell.animation_player.play("RESET")
	await current_active_cell.animation_player.animation_finished
	current_active_cell.animation_player.play("Idle")
	cells_turn_queue.append(current_active_cell)
	player_cell_is_active = false

	await $ActionTimerNode2D.turn_timer_timeout
	_start_next_turn()
	

func _get_uuid(x, y):
	return uuid_map[y * settings.height + x]

func _input(event):
	if event.is_action_pressed("ui_right"):
		_update_new_positions(Direction.Right)
		_update_cells_map()
		_end_current_turn()
	elif event.is_action_pressed("ui_left"):
		_update_new_positions(Direction.Left)
		_update_cells_map()
		_end_current_turn()
	elif event.is_action_pressed("ui_down"):
		_update_new_positions(Direction.Down)
		_update_cells_map()
		_end_current_turn()
	elif event.is_action_pressed("ui_up"):
		_update_new_positions(Direction.Up)
		_update_cells_map()
		_end_current_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_map()

	
func initialise_random_map():
	cells_map_initialiser = []
	var row
	for i in range(settings.height):
		row = []
		for j in range(settings.width):
			row.append(0)
		cells_map_initialiser.append(row)
	return cells_map_initialiser

func sample_map_1():
	var sample: Array = [
		[0,1,1,1,0],
		[1,0,2,0,1],
		[0,1,2,1,0],
		[1,0,2,0,1],
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
			if cells_map_initialiser[j][i] > 0:
				var cell: MushMashCell = cells_map[j][i]
				cell.position = Vector2(150 * i, 150 * j)
				push_error(get_parent().name)
				$GridOrigin.add_child(cell)
				cell.animation_player.play("Idle")


func _update_map():
	var all_cells = _get_all_cells()
	var destination
	var direction
	for cell: MushMashCell in all_cells:
		destination = Vector2(150 * cell.settings.x, 150 * cell.settings.y)
		if settings.cell_movement_type == MushMashMapSettings.CellMovementType.Instant:
			cell.position = destination

		elif settings.cell_movement_type == MushMashMapSettings.CellMovementType.Linear:
			if destination != cell.position:
				direction = (destination - cell.position).normalized()
				cell.position = cell.position + 5 * direction

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

func _on_cell_positions_changed():
	pass

func _update_single_cell(old_x, old_y, new_x, new_y):
	var cell: MushMashCell = cells_map[old_y][old_x]
	if not cell.settings.is_movable:
		return
	cell.settings.new_x = new_x
	cell.settings.new_y = new_y

func _update_cells_map():
	var all_cells = _get_all_cells()
	for cell: MushMashCell in all_cells:
		if cell.settings.new_x != cell.settings.x:
			cell.settings.x = cell.settings.new_x
		if cell.settings.new_y != cell.settings.y:
			cell.settings.y = cell.settings.new_y

	
	
	var new_cells_map: Dictionary = CommonFunctions.nulls_2D_map(settings.height, settings.width)
	for cell in _get_all_cells():
		new_cells_map[cell.settings.new_y][cell.settings.new_x] = cell
	cells_map = new_cells_map
	
	print("\n\n----- New Maps ------")
	print_cells_map()
	print_uuid_map()	

func _get_all_cells():
	var all_cells = []
	for j in range(settings.height):
		for i in range(settings.width):
			if cells_map[j][i] != null:
				all_cells.append(cells_map[j][i])
	return all_cells





func _resolve_cell_collisions():
		# 0 - Build first collusion map, where a cell colludes if
		# it tries to move to the new or old position of any other cell
		# 1 - Look for a cell A that has no collisions
		# 2 - Resolve A and allow it to move
		# 3 - If another cell was trying to move to the old
		# position of A, it now has no collisions with A
		# 4 - Repeat
		
	var all_cells_1 = _get_all_cells()
	var collisions = CommonFunctions.zeros_2D_array(len(all_cells_1), len(all_cells_1))
	
	var current_cell
	var other_cell
	for j in range(len(all_cells_1)):
		for i in range(len(all_cells_1)):
			current_cell = all_cells_1[j]
			other_cell = all_cells_1[i]
			if i == j:
				collisions[j][i] = 0
				
			# Collision if a cell moves into the new position of another cell
			elif [current_cell.settings.new_x, current_cell.settings.new_y] == [other_cell.settings.new_x, other_cell.settings.new_y]:
				collisions[j][i] = 1
			
			# Collision if a cell moves into the old position of another cell
			elif [current_cell.settings.new_x, current_cell.settings.new_y] == [other_cell.settings.x, other_cell.settings.y]:
				collisions[j][i] = 1
	
	var detected_zero_collisions_row
	var resolved_cells = []
	while true:
		detected_zero_collisions_row = false
		for j in len(collisions):
			current_cell = all_cells_1[j]
			if CommonFunctions.sum_array(collisions[j]) == 0 and (j not in resolved_cells):
				detected_zero_collisions_row = true

				for k in len(all_cells_1):
					if [current_cell.settings.x, current_cell.settings.y] == [all_cells_1[k].settings.new_x, all_cells_1[k].settings.new_y]:
						collisions[j][k] = 0
						collisions[k][j] = 0

				resolved_cells.append(j)
				break

		if not detected_zero_collisions_row:
			break
			
	# Remove move attempt of all unresolved cell
	for j in len(all_cells_1):
		if j not in resolved_cells:
			var cell = all_cells_1[j]
			cell.settings.new_x = cell.settings.x
			cell.settings.new_y = cell.settings.y



func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell)
	
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
