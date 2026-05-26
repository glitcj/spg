@tool
extends Node
class_name _RPGM_Mover


@export var is_collision = false
static var tiles_with_rpgm_collision = []

signal finished_movement
enum MovementType {Linear, Random, Exponential}

@export var type = MovementType.Linear as MovementType
@export var facing = Vector2i(0, 1) as Vector2i:
	set(v):
		facing = v
		face.bind(facing).call_deferred()

@export var speed = 0.5 as float

@export var map_position: Vector2i = Vector2i(0, 0):
	set(v):
		map_position = v
		_update_tiles_with_rpgm_collision(map_position, v)
		
		
		
		if Engine.is_editor_hint():
			_quantise_position()

func get_map(): return find_parent("_RPGM_Map") as _RPGM_Map





var is_moving = false
func _ready() -> void:
	if true or Engine.is_editor_hint():
		
		# Fixes conflict between _Map and _Mover
		# Refactor both
		await get_tree().process_frame

		_quantise_position()
		
		_update_tiles_with_rpgm_collision(map_position, map_position)
		
		

func tilemap_to_global_position(tile_position : Vector2i):
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	var map_tile_global_center = base_layer.to_global(base_layer.map_to_local(map_position))
	return map_tile_global_center
	
func teleport(tile_position : Vector2i):
	if not is_inside_tree():
		return
	
	map_position = tile_position
	get_parent().global_position = tilemap_to_global_position(tile_position)
	


func _quantise_position():
	if not is_inside_tree():
		return
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	var map_tile_global_center = base_layer.to_global(base_layer.map_to_local(map_position))
	
	get_parent().global_position = map_tile_global_center


func _update_tiles_with_rpgm_collision(old_position, new_position):
	if get_map() != null:
		
		tiles_with_rpgm_collision = []
		for m : _RPGM_Mover in get_map().find_children("*", "_RPGM_Mover"):
			if not m.is_collision:
				continue
			tiles_with_rpgm_collision.append(m.map_position)
			
		_update_tilemap_collision_debugger()


static var all_collision_debugging_rects = []
func _update_tilemap_collision_debugger():
	for r : ColorRect in all_collision_debugging_rects:
		r.queue_free()
	all_collision_debugging_rects = []
	
	print(tiles_with_rpgm_collision)
	if get_map():
		var base_layer = get_map().find_child("L1 Base") as TileMapLayer
		for tile_position : Vector2i in tiles_with_rpgm_collision:
			var map_tile_global_center = base_layer.to_global(base_layer.map_to_local(tile_position))
			var map_tile_local_center = base_layer.map_to_local(tile_position)
			
			var rect = ColorRect.new()
			rect.color = Color.RED
			rect.size = Vector2(32, 32)
			rect.position = map_tile_local_center # map_tile_global_center
			rect.z_index = 100
			
			# find_parent("_RPGM_Map").add_child(rect)
			base_layer.add_child(rect)
			all_collision_debugging_rects.append(rect)


func move(tile_vector : Vector2i) -> _RPGM_Mover:
	map_position = map_position + tile_vector

	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	var target_global = base_layer.to_global(base_layer.map_to_local(map_position))
	
	var displacement = target_global - get_parent().global_position 
	facing = Vector2i(tile_vector / tile_vector.length())
	
	is_moving = true
	await displace(displacement)
	is_moving = false
	
	return self
	


func move_v1(tile_vector : Vector2i) -> _RPGM_Mover:
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	
	var target_global = base_layer.to_global(base_layer.map_to_local(map_position + tile_vector))
	var displacement = target_global - get_parent().global_position 
	
	facing = Vector2i(tile_vector / tile_vector.length())
	
	is_moving = true
	await displace(displacement)
	map_position = map_position + tile_vector
	is_moving = false
	
	return self
	
func face(tile_vector : Vector2i):
	var normalised_vector = Vector2(tile_vector).normalized()
	var portrait = get_parent().find_child("_RPGM_Portrait") as _RPGM_Portrait
	if portrait:
		if normalised_vector == Vector2(1, 0):
			portrait.face_right()
		elif normalised_vector == Vector2(-1, 0):
			portrait.face_left()
		elif normalised_vector == Vector2(0, 1):
			portrait.face_down()
		elif normalised_vector == Vector2(0, -1):
			portrait.face_up()
	return self


func displace(displacement : Vector2):
	var tween = get_parent().create_tween()
	if type == MovementType.Exponential:
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property(get_parent(), "global_position", get_parent().global_position + displacement, 1/speed).finished
	
	finished_movement.emit()

func get_facing_direction():
	return facing
	
	"""
	var portrait = get_parent().find_child("_RPGM_Portrait") as _RPGM_Portrait
	var animation_name = portrait.animation_player.current_animation
	
	if animation_name == "move_down":
		return Vector2i(0, 1)
	elif animation_name == "move_up":
		return Vector2i(0, -1)
	elif animation_name == "move_right":
		return Vector2i(1, 0)
	elif animation_name == "move_left":
		return Vector2i(-1, 0)
	"""
		
func tile_has_collision(tile_pos: Vector2i) -> bool:
	for layer : TileMapLayer in get_map().layers:
		var tile_data = layer.get_cell_tile_data(tile_pos)
		
		if tile_data == null:
			continue
	
		if tile_data.get_collision_polygons_count(0) > 0:
			return true
	if tile_has_rpgm_collision(tile_pos):


		print(tile_pos)
		return true
	return false

func tile_has_rpgm_collision(position):
	print(position)
	if tiles_with_rpgm_collision.has(position):
		pass
	return tiles_with_rpgm_collision.has(position) # find(position)

# Refactor _Mover
# Refactor _Map

# Refactor common events ? have event root extend script directly ?
# No have it extend _RPGM_Event and simple var exports and setters as a built in script in the event root
# Setters set the vars of component children for easy tree access
# And add common script as a components
# And saved as e.g. _common_event_teleport.tscn

# Refactor rooms ? npcs as children of rooms ?
