@tool
extends Node
class_name _RPGM_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}

var is_moving = false:
	set(value):
		is_moving = value

@export var is_collision = false
@export var speed = 0.5 as float
@export var type = MovementType.Linear as MovementType

@export var facing = Vector2i(1, 0) as Vector2i


func _editor_update():
	if "is_collision" in get_parent():
		is_collision = get_parent().is_collision
	if "facing" in  get_parent():
		facing = get_parent().facing
	face(facing)
	
@export var map_position: Vector2i = Vector2i(0, 0):
	set(v):
		map_position = v
		_update_tiles_with_rpgm_collision()
		if Engine.is_editor_hint(): _quantise_position()

func get_map(): return find_parent("_RPGM_Map") as _RPGM_Map
func get_base_layer(): return get_map().find_child("L1 Base") as TileMapLayer
func _get_event(): return get_parent() as _RPGM_Event 

@onready var base_layer = get_base_layer()

func _ready() -> void:
	await get_tree().process_frame
	_update_tiles_with_rpgm_collision()
	await get_tree().process_frame
	face(facing)
	

func tilemap_to_global_position(tile_position : Vector2i):
	return base_layer.to_global(base_layer.map_to_local(tile_position))
	
func teleport(tile_position : Vector2i):
	if not is_inside_tree(): return
	
	map_position = tile_position
	get_parent().global_position = tilemap_to_global_position(tile_position)
	
func _quantise_position():
	get_parent().global_position = tilemap_to_global_position(map_position)

static var tiles_with_rpgm_collision = []
func _update_tiles_with_rpgm_collision():
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
	
	if get_map():
		for tile_position : Vector2i in tiles_with_rpgm_collision:
			var map_tile_local_center = base_layer.map_to_local(tile_position)
			
			var rect = ColorRect.new()
			rect.color = Color.RED
			rect.size = Vector2(32, 32)
			rect.position = map_tile_local_center # map_tile_global_center
			rect.z_index = 100
			
			base_layer.add_child(rect)
			all_collision_debugging_rects.append(rect)
			
			
func move_to_map_position(target_map_position):
	await move(target_map_position - map_position)

func face_map_position(target_map_position):
	face(target_map_position - map_position)
	

func move(tile_vector : Vector2i) -> _RPGM_Mover:
	map_position = map_position + tile_vector # activates setter
	var displacement = tilemap_to_global_position(map_position) - get_parent().global_position 
	
	is_moving = true
	await displace(displacement)
	is_moving = false
	
	return self


func walk(tile_vector : Vector2i) -> _RPGM_Mover:
	face(tile_vector)
	await move(tile_vector)
	return self



func face(tile_vector : Vector2i):
	var normalised_vector = Vector2(tile_vector).normalized()
	facing = Vector2i(normalised_vector)
	
	
	if not (facing.length() != 1 or facing.length() != 0):
		print(facing, facing.length())
		pass
	
	var portrait = get_parent().find_child("_RPGM_Portrait") as _RPGM_Portrait
	if portrait: portrait.facing = Vector2(facing)
		
	return self


func displace(displacement : Vector2):
	var tween = get_parent().create_tween()
	if type == MovementType.Exponential:
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property(get_parent(), "global_position", get_parent().global_position + displacement, 1/speed).finished
	
	finished_movement.emit()
	
func tile_has_collision(tile_pos: Vector2i) -> bool:
	for layer : TileMapLayer in get_map().layers:
		var tile_data = layer.get_cell_tile_data(tile_pos)
		
		if tile_data == null:
			continue
	
		if tile_data.get_collision_polygons_count(0) > 0:
			return true
	if tile_has_rpgm_collision(tile_pos):
		return true
	return false

func tile_has_rpgm_collision(position):
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
