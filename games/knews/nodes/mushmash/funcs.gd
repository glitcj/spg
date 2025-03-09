extends Node
class_name _MushMash_Funcs

var mushmash: _MushMashMap = get_parent()

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
	return randi() % _MushMashMap.Direction.size()


func make_all_cells_immovable():
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.is_movable = false


func reset_idle_animation_of_all_cells():
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.animation_player.play("RESET")
		cell.animation_player.queue("Idle")


func get_cells_in_tilemap():
	
	# var cells_map = CommonFunctions.nulls_2D_map(settings.width, settings.height)
	var cells_map := {}
	
	var tilemap_layer: TileMapLayer = get_parent().tilemap
	var tilemap_hash_map_to_world: Dictionary = {}  # Dictionary to store tile mappings
	var tilemap_hash_world_to_map: Dictionary = {}  # Dictionary to store tile mappings
	


	var world_pos
	for local_pos: Vector2i in tilemap_layer.get_used_cells():
		world_pos = tilemap_layer.to_global(tilemap_layer.map_to_local(local_pos))
	
		print(local_pos, world_pos, tilemap_layer.local_to_map(world_pos))
		tilemap_hash_map_to_world[local_pos] = world_pos  # Store mapping in dictionary
		tilemap_hash_world_to_map[world_pos] = local_pos

		

	print(tilemap_hash_world_to_map)
	for cell: MushMashCell in get_parent().on_map_cells:
	# for cell: MushMashCell in get_parent()._get_all_cells():
	
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
				print("LOWEST", cell.position, cell.global_position, world_position, lowest_distance_world_position, lowest_distance_tilemap_position, distance)
				var x = 0
				pass
		
		# print(cell, lowest_distance_world_position, lowest_distance_tilemap_position)
		cell.global_position = lowest_distance_world_position
		cell.x = lowest_distance_tilemap_position[0]
		cell.y = lowest_distance_tilemap_position[1]
		
		if cell.y not in cells_map.keys():
			cells_map[cell.y] = {}
			
		cells_map[cell.y][cell.x] = cell
		
	# print(cells_map)		
	return cells_map



func get_tilemap_as_array():
	pass



	
func get_tilemap_uuid_map():
	pass
