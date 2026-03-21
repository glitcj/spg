@tool
extends Node
class_name _Peekaboo_Mover

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
		_quantise_position() # TODO: Move quantise_position to _peekaboo_map ?
		# correct_position()
		
		
var is_moving = false
func _ready() -> void:
	if Engine.is_editor_hint():
		_quantise_position()

func _quantise_position():
	if not is_inside_tree():
		return
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var l1 = map.find_child("L1") as TileMapLayer
	var map_tile_global_center = l1.to_global(l1.map_to_local(map_position))
	
	if get_parent().has_node("RigidBody2D"):
		get_parent().find_child("RigidBody2D").freeze = Engine.is_editor_hint()
	get_parent().global_position = map_tile_global_center
	
func move_to_tile(tile_position : Vector2i):
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.find_child("L1") as TileMapLayer

	
	var target_global = layer.to_global(layer.map_to_local(tile_position))
	var displacement = target_global - get_parent().global_position
	await displace(displacement)


func move(tile_vector : Vector2i):
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	
	var target_global = layer.to_global(layer.map_to_local(map_position + tile_vector))
	var displacement = target_global - get_parent().global_position
	
	is_moving = true
	await displace(displacement)
	map_position = map_position + tile_vector
	is_moving = false
	
	return self
	
func face(tile_vector : Vector2i):
	var portrait = get_parent().find_child("_Peekaboo_Portrait") as _Peekaboo_Portrait
	if portrait:
		if tile_vector == Vector2i(1, 0):
			portrait.face_right()
		elif tile_vector == Vector2i(-1, 0):
			portrait.face_left()
		elif tile_vector == Vector2i(0, 1):
			portrait.face_down()
		elif tile_vector == Vector2i(0, -1):
			portrait.face_up()
	return self


func displace(displacement : Vector2):
	var tween = get_parent().create_tween()
	
	if type == MovementType.Exponential:
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	await tween.tween_property(get_parent(), "global_position", get_parent().global_position + displacement, 1/speed).finished
	
	finished_movement.emit()
	# map_position = closest_map_position()


func wait(time : float = 1.0):
	await get_tree().create_timer(time).timeout



func closest_map_position() -> Vector2i:
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.find_child("L1") as TileMapLayer
	
	return layer.local_to_map(layer.to_local(get_parent().global_position))
	
	
	
	
func tile_has_collision(tile_pos: Vector2i) -> bool:
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	
	for layer : TileMapLayer in map.layers:
		
		# 1. Get the TileData at the specific grid position
		var tile_data = layer.get_cell_tile_data(tile_pos)
		
		# 2. If the cell is empty, tile_data will be null
		if tile_data == null:
			continue
	
		# 3. Check the collision polygons in Physics Layer 0
		# get_collision_polygons_count returns 0 if no collision is defined
		if tile_data.get_collision_polygons_count(0) > 0:
			return true
	return false
