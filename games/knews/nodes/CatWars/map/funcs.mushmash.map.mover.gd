extends Node
class_name _MushMash_Map_Mover

@onready var mushmash: _MushMash = get_parent().get_parent()
@onready var map: _MushMash_Map = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_map():
	var all_cells = mushmash._get_all_cells()
	var destination
	var direction
	for cell: MushMashCell in all_cells:
		destination = map.get_tilemap_cell_position(cell.map_position.x, cell.map_position.y)
		if mushmash.constants.cell_movement_type == mushmash.constants.CellMovementType.Instant:
			cell.position = destination

		elif mushmash.constants.cell_movement_type == mushmash.constants.CellMovementType.Linear:
			if destination != cell.position:
				direction = (destination - cell.position).normalized()
				cell.position = cell.position + 5 * direction

func _update_new_positions(cells, direction: int):
	if true:
		print("\n\n----- Old Maps ------")
		print_cells_map()
		print_uuid_map()	
		pass
		
		var x = 0
	
	for cell in cells:
		if not cell.is_movable:
			continue
			
		var i = cell.map_position.x
		var j = cell.map_position.y

		if direction == _MushMash_Map.Direction.Down:
			_update_single_cell(cell, i, j + 1)

		elif direction == _MushMash_Map.Direction.Up:
			_update_single_cell(cell, i, j - 1)
			
		elif direction == _MushMash_Map.Direction.Left:
			_update_single_cell(cell, i - 1, j)
			
		elif direction == _MushMash_Map.Direction.Right:
			_update_single_cell(cell, i + 1, j)

	map.mover._resolve_cell_collisions()

func _on_cell_positions_changed():
	pass

func _update_single_cell(cell, new_x, new_y):
	cell.new_map_position = Vector2i(new_x, new_y)
	cell.new_map_position.x = new_x
	cell.new_map_position.y = new_y

func _update_cells_map():
	var all_cells = mushmash._get_all_cells()
	for cell: MushMashCell in all_cells:
		if cell.new_map_position.x != cell.map_position.x:
			cell.map_position.x = cell.new_map_position.x
		if cell.new_map_position.y != cell.map_position.y:
			cell.map_position.y = cell.new_map_position.y

	var new_cells_map: Dictionary = {}
	for cell in mushmash._get_all_cells():
		if cell.new_map_position.y not in new_cells_map.keys():
			new_cells_map[cell.new_map_position.y] = {}
		new_cells_map[cell.new_map_position.y][cell.new_map_position.x] = cell
	mushmash.map.cells_map = new_cells_map
	
	if false:
		print("\n\n----- New Maps ------")
		print_cells_map()
		print_uuid_map()	




func _resolve_cell_collisions():
		# 0 - Build first collusion map, where a cell colludes if
		# it tries to move to the new or old position of any other cell
		# 1 - Look for a cell A that has no collisions
		# 2 - Resolve A and allow it to move
		# 3 - If another cell was trying to move to the old
		# position of A, it now has no collisions with A
		# 4 - Repeat
		
	var all_cells_1 = mushmash._get_all_cells()
	var collisions = CommonFunctions.zeros_2D_array(len(all_cells_1), len(all_cells_1))
	
	var current_cell
	var other_cell
	for j in range(len(all_cells_1)):
		for i in range(len(all_cells_1)):
			current_cell = all_cells_1[j]
			other_cell = all_cells_1[i]
			
			var is_future_future_collision = [current_cell.new_map_position.x, current_cell.new_map_position.y] == [other_cell.new_map_position.x, other_cell.new_map_position.y]
			var is_future_past_collision = [current_cell.new_map_position.x, current_cell.new_map_position.y] == [other_cell.map_position.x, other_cell.map_position.y]
			var is_tilemap_collision = _is_tilemap_collision(current_cell.new_map_position.x, current_cell.new_map_position.y)
			
			if i == j:
				collisions[j][i] = 0
				
			# Collision if a cell moves into the new position of another cell
			# elif [current_cell.new_map_position.x, current_cell.new_y] == [other_cell.new_map_position.x, other_cell.new_y]:
			elif is_future_future_collision:
				collisions[j][i] = 1
			elif is_tilemap_collision:
				collisions[j][i] = 1			
			# Collision if a cell moves into the old position of another cell
			# elif [current_cell.new_map_position.x, current_cell.new_y] == [other_cell.x, other_cell.y]:
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
					if [current_cell.map_position.x, current_cell.map_position.y] == [all_cells_1[k].new_map_position.x, all_cells_1[k].new_map_position.y]:
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
			cell.new_map_position.x = cell.map_position.x
			cell.new_map_position.y = cell.map_position.y

func _is_tilemap_collision(x, y):
	# Get the tile data from the layer (assuming layer 0, adjust if necessary)
	# var tile_data: TileData = tilemap_layer.get_cell_tile_data(0, tile_pos)  # Use correct layer index
	var tile_data: TileData
	var is_collision
	for c in get_children():
		if c is not TileMapLayer:
			continue
		var tilemap_layer: TileMapLayer = c
		tile_data = tilemap_layer.get_cell_tile_data(Vector2i(x,y))  # Use correct layer index
		is_collision = (tile_data != null) and (tile_data.get_collision_polygons_count(0) > 0)
		
		if is_collision:
			return true

		# Check if the tile has any collision polygons
	return false


func get_movable_vector(position: Vector2i, direction: _MushMash_Map.Direction):
	var max_x_vector_length = 5
	var max_y_vector_length = 5
	var movable_positions = []
	
	for i in range(max_x_vector_length):
		var candidate = position + _MushMash_Map.DirectionVector[direction] * i
		if not _is_tilemap_collision(candidate.map_position.x, candidate.map_position.y):
			movable_positions.append(candidate)
			
	return movable_positions



func print_cells_map():
	print("Cells Map")
	for j in map.cells_map.keys(): # range(constants.height):
		var line = ""
		for i in map.cells_map[j].keys(): # range(constants.height):
			var cell: MushMashCell = map.cells_map[j][i]
			if cell != null:
				line = line + str(cell.map_position.x) + "," + str(cell.map_position.y) + "   "
			else:
				line = line + "null" + "   "
		print(line)

		
func print_uuid_map(max_uuid_digits: int = 4):
	print("UUID Map")
	for j in map.cells_map.keys(): # range(constants.height):
		var line = ""
		for i in map.cells_map[j].keys(): # range(constants.height):
			if map.cells_map[j][i]:
				line = line + map.cells_map[j][i].uuid.substr(0,max_uuid_digits) + "   "
			else:
				line = line + "null" + "   "
		print(line)
