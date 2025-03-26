extends Node
class_name _MushMash_Map

@onready var mushmash: _MushMash = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func sample_map_1():
	var sample: Array = [
		[0,1,1,1,0],
		[1,0,2,0,1],
		[0,1,2,1,0],
		[1,0,2,0,1],
		[0,1,1,1,0]
		]
	return sample



func sample_map_3():
	var sample: Array = [
		[0,1,1,1,0,0,0,0],
		[1,0,2,0,1,0,0,0],
		[0,1,2,1,0,0,0,0],
		[1,0,2,0,1,0,0,0],
		[0,1,1,1,0,0,0,0]
		]
	return sample


func sample_map_4():
	var sample: Array = [
		[0,0,1,0,0,0,0,0],
		[1,0,0,0,0,0,0,0],
		[0,1,2,0,0,0,0,0],
		[1,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0]
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


func random_opponent_action():
	return randi() % _MushMash.Direction.size()


func make_all_cells_immovable():
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.is_movable = false


func reset_idle_animation_of_all_cells():
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.animation_player.play("RESET")
		cell.animation_player.queue("Idle")


func get_cells_in_tilemap():	
	var cells_map := {}
	
	var tilemap_layer: TileMapLayer = get_parent().tilemap
	var tilemap_hash_map_to_world: Dictionary = {}  # Dictionary to store tile mappings
	var tilemap_hash_world_to_map: Dictionary = {}  # Dictionary to store tile mappings
	


	var world_pos
	for local_pos: Vector2i in tilemap_layer.get_used_cells():
		world_pos = tilemap_layer.to_global(tilemap_layer.map_to_local(local_pos))
		tilemap_hash_map_to_world[local_pos] = world_pos  # Store mapping in dictionary
		tilemap_hash_world_to_map[world_pos] = local_pos

		

	# print(tilemap_hash_world_to_map)
	for cell: MushMashCell in get_parent().on_map_cells:	
		var lowest_distance_found = 100000000
		var lowest_distance_world_position: Vector2
		var lowest_distance_tilemap_position: Vector2
		for world_position: Vector2 in tilemap_hash_world_to_map.keys():
			var tilemap_cell_world_position_x = world_position[0]
			var tilemap_cell_world_position_y = world_position[1]
			var distance = world_position.distance_to(cell.global_position)# abs(cell.position.x - tilemap_cell_world_position_x) + abs(cell.position.y - tilemap_cell_world_position_y)
			pass
			
			if distance < lowest_distance_found:
				lowest_distance_found = distance
				lowest_distance_world_position = world_position
				lowest_distance_tilemap_position = tilemap_hash_world_to_map[lowest_distance_world_position]
				# print("LOWEST", cell.position, cell.global_position, world_position, lowest_distance_world_position, lowest_distance_tilemap_position, distance)
				var x = 0
				pass
		
		# print(cell, lowest_distance_world_position, lowest_distance_tilemap_position)
		cell.global_position = lowest_distance_world_position
		cell.x = lowest_distance_tilemap_position[0]
		cell.y = lowest_distance_tilemap_position[1]
		cell.new_x = cell.x
		cell.new_y = cell.y
		
		cell.uuid = Variables.generate_uuid()
		
		if cell.y not in cells_map.keys():
			cells_map[cell.y] = {}
			
		cells_map[cell.y][cell.x] = cell
		
	# print(cells_map)		
	return cells_map



func get_tilemap_as_array():
	pass
	
func get_tilemap_uuid_map():
	pass
	
func get_tilemap_cell_position(x, y):
	var tilemap_layer: TileMapLayer = get_parent().tilemap
	var local_pos = Vector2i(x,y)
	var world_pos: Vector2 = tilemap_layer.to_global(tilemap_layer.map_to_local(local_pos))
	return world_pos


func update_hud_face(texture_: Texture2D):
	get_parent().hud_face.texture = texture_
	get_parent().hud_face.scale = Vector2(3,3)

func resolve_damage_and_cell_placement():
	pass

func get_on_map_cell(x, y):
	if y in mushmash.cells_map.keys():
		if x in mushmash.cells_map[y].keys():
			return mushmash.cells_map[y][x]
	return null


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
	for tilemap_layer in get_children():
		if tilemap_layer is not TileMapLayer:
			continue
		tile_data = tilemap_layer.get_cell_tile_data(Vector2i(x,y))  # Use correct layer index
		is_collision = (tile_data != null) and (tile_data.get_collision_polygons_count(0) > 0)
		
		if is_collision:
			return true

		# Check if the tile has any collision polygons
	return false
