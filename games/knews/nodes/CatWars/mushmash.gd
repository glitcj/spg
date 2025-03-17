extends Node2D
class_name _MushMashMap


# TODO: Add Birds
# TODO: Add fat birds (Fat chickens that block movement)
# TODO: Add Sky Parallex background
# TODO: Add cell selection in player turn

# TODO: Move TurnController funcs to a separate node TurnController
# TODO: Refactor Mushmash into many composite nodes
# TODO: Add ninja sprite parsing

# TODO: This should be used only once to initialise map
var cells_map_initialiser: Array

# var settings: MushMashMapSettings
var cells_map: Dictionary
var uuid_map := {}

enum Direction {Up, Down, Left, Right}

# Set references so all components can talk to each other
@onready var turner: _MushMash_Turner = $Turner
@onready var funcs : _MushMash_Funcs = $Funcs
@onready var input_handles : _MushMash_InputHandles = $InputHandles
@onready var ai : _MushMash_AI  = $AI

@onready var hud_face: Sprite2D = $Hud/Face
@onready var tilemap: TileMapLayer = $TileMapsNode/TileMapLayerMain
@onready var on_map_cells: Array = $TileMapsNode/OnMapNodes.get_children()

@onready var constants = $Constants
@onready var settings: MushMashMapSettings = $Constants # Deprecate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cells_map_initialiser = $Funcs.sample_map_4()
	
	cells_map = funcs.get_cells_in_tilemap()
	print(constants.height)
	print(constants.width)
	$Turner._initialise_player_cells_turn_queue()
	$Turner._initialise_opponent_cells_turn_queue()	
	
	absolute_resize_tilemap()
	
func _initialise_uuid_map():
	for j in constants.height:
		for i in constants.width:
			uuid_map[j * constants.height + i] = _MushMash_Constants.get_cell_uuid(i, j)

func _initialise_cells_map():
	pass



func _get_uuid(x, y):
	return uuid_map[y * constants.height + x]

func _input(event):
	$InputHandles.handle_inputs(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_map()
	_update_console()


func _update_console():
	var O_O_ = ""
	for cell: MushMashCell in $Turner.player_cells_turn_queue:
		O_O_ = O_O_ + "%s\t" % cell.uuid.substr(0,6)
	
	$Console.text = ""
	
func initialise_random_map():
	cells_map_initialiser = []
	var row
	for i in range(constants.height):
		row = []
		for j in range(constants.width):
			row.append(0)
		cells_map_initialiser.append(row)
	return cells_map_initialiser




func draw_cells():
	var uuid	
	for j in range(constants.height):
		for i in range(constants.width):
			if cells_map_initialiser[j][i] > 0:
				var cell: MushMashCell = cells_map[j][i]
				cell.position = Vector2(150 * i, 150 * j)
				push_error(get_parent().name)
				$GridOrigin.add_child(cell)
				
				# cell.change_sprite_sheet(cell.cell_sprite)
				
				# print(cell.cell_sprite)
				cell.animation_player.play("Idle")


func _update_map():
	var all_cells = _get_all_cells()
	var destination
	var direction
	for cell: MushMashCell in all_cells:
		# destination = Vector2(150 * cell.x, 150 * cell.y)
		destination = funcs.get_tilemap_cell_position(cell.x, cell.y)
		# if settings.cell_movement_type == MushMashMapSettings.CellMovementType.Instant:
		if constants.cell_movement_type == constants.CellMovementType.Instant:
			cell.position = destination

		# elif settings.cell_movement_type == MushMashMapSettings.CellMovementType.Linear:
		elif constants.cell_movement_type == constants.CellMovementType.Linear:
			if destination != cell.position:
				direction = (destination - cell.position).normalized()
				cell.position = cell.position + 5 * direction

func _update_new_positions(direction: int):
	if true:
		print("\n\n----- Old Maps ------")
		print_cells_map()
		print_uuid_map()	
		pass
		
		var x = 0
	
	for cell in _get_all_cells():
		if not cell.is_movable:
			continue
			
		var i = cell.x
		var j = cell.y
		

		if direction == Direction.Down:
			# _update_single_cell(i, j, i, j + 1)
			_update_single_cell(cell, i, j + 1)

		elif direction == Direction.Up:
			# _update_single_cell(i, j, i, j - 1)
			_update_single_cell(cell, i, j - 1)
			
		elif direction == Direction.Left:
			# _update_single_cell(i, j, i - 1, j)
			_update_single_cell(cell, i - 1, j)
			
		elif direction == Direction.Right:
			# _update_single_cell(i, j, i + 1, j)
			_update_single_cell(cell, i + 1, j)

	_resolve_cell_collisions()

func _on_cell_positions_changed():
	pass

func _update_single_cell(cell, new_x, new_y):
	# var cell: MushMashCell = cells_map[old_y][old_x]
	# if not cell.is_movable:
	# 	return
	cell.new_x = new_x
	cell.new_y = new_y

func _update_cells_map():
	var all_cells = _get_all_cells()
	for cell: MushMashCell in all_cells:
		if cell.new_x != cell.x:
			cell.x = cell.new_x
		if cell.new_y != cell.y:
			cell.y = cell.new_y

	var new_cells_map: Dictionary = {}
	for cell in _get_all_cells():
		if cell.new_y not in new_cells_map.keys():
			new_cells_map[cell.new_y] = {}
		new_cells_map[cell.new_y][cell.new_x] = cell
	cells_map = new_cells_map
	
	if false:
		print("\n\n----- New Maps ------")
		print_cells_map()
		print_uuid_map()	

func _get_all_cells():
	var all_cells = []
	
	"""
	for j in range(settings.height):
		for i in range(settings.width):
	"""
	for j in cells_map.keys():
		for i in cells_map[j].keys():
			if cells_map[j][i] != null:
				all_cells.append(cells_map[j][i])
	return all_cells





func _get_all_typed_cells(types: Array = [MushMashCell.CellTypes.Player]):
	var all_cells = []
	
	"""
	for j in range(settings.height):
		for i in range(settings.width):
	"""
			
			
	for j in cells_map.keys():
		for i in cells_map[j].keys():
			var cell: MushMashCell = cells_map[j][i]
			if cell != null and cell.type in types:
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
			
			var is_future_future_collision = [current_cell.new_x, current_cell.new_y] == [other_cell.new_x, other_cell.new_y]
			var is_future_past_collision = [current_cell.new_x, current_cell.new_y] == [other_cell.x, other_cell.y]
			var is_tilemap_collision = _is_tilemap_collision(current_cell.new_x, current_cell.new_y)
			
			if i == j:
				collisions[j][i] = 0
				
			# Collision if a cell moves into the new position of another cell
			# elif [current_cell.new_x, current_cell.new_y] == [other_cell.new_x, other_cell.new_y]:
			elif is_future_future_collision:
				collisions[j][i] = 1
			elif is_tilemap_collision:
				collisions[j][i] = 1			
			# Collision if a cell moves into the old position of another cell
			# elif [current_cell.new_x, current_cell.new_y] == [other_cell.x, other_cell.y]:
			elif is_future_past_collision:
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
					if [current_cell.x, current_cell.y] == [all_cells_1[k].new_x, all_cells_1[k].new_y]:
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
			cell.new_x = cell.x
			cell.new_y = cell.y

func _is_tilemap_collision(x, y):
	# Get the tile data from the layer (assuming layer 0, adjust if necessary)
	# var tile_data: TileData = tilemap_layer.get_cell_tile_data(0, tile_pos)  # Use correct layer index
	var tile_data: TileData
	var is_collision
	for tilemap_layer in $TileMapsNode.get_children():
		if tilemap_layer is not TileMapLayer:
			continue
		tile_data = tilemap_layer.get_cell_tile_data(Vector2i(x,y))  # Use correct layer index
		is_collision = (tile_data != null) and (tile_data.get_collision_polygons_count(0) > 0)
		
		if is_collision:
			return true

		# Check if the tile has any collision polygons
	return false

func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell)
	
func print_cells_map():
	print("Cells Map")
	for j in cells_map.keys(): # range(constants.height):
		var line = ""
		for i in cells_map[j].keys(): # range(constants.height):
			var cell: MushMashCell = cells_map[j][i]
			if cell != null:
				line = line + str(cell.x) + "," + str(cell.y) + "   "
			else:
				line = line + "null" + "   "
		print(line)

		
func print_uuid_map(max_uuid_digits: int = 4):
	print("UUID Map")
	for j in cells_map.keys(): # range(constants.height):
		var line = ""
		for i in cells_map[j].keys(): # range(constants.height):
			if cells_map[j][i]:
				line = line + cells_map[j][i].uuid.substr(0,max_uuid_digits) + "   "
			else:
				line = line + "null" + "   "
		print(line)



func absolute_resize_tilemap(resize_width = 80, resize_height = 80):
	var tileset: TileSet = $TileMapsNode/TileMapLayerMain.tile_set
	var scaler = resize_width/tileset.tile_size.x
	
	$TileMapsNode.scale = Vector2(scaler, scaler)
	
func place_cells_on_tile_map():
	pass
