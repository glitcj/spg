@tool
extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}

@export var peekaboo : _PeekaBoo
@export var type = MovementType.Linear as MovementType

@export var map_position: Vector2i = Vector2i(0, 0):
	set(v):
		map_position = v
		_quantise_position() # TODO: Move quantise_position to _peekaboo_map ?
		# correct_position()
		
		
		
func _ready() -> void:
	if Engine.is_editor_hint():
		_quantise_position()

func _quantise_position():
	if not is_inside_tree():
		return
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var map_tile_global_center = map.l1.to_global(map.l1.map_to_local(map_position))
	
	get_parent().find_child("RigidBody2D").freeze = Engine.is_editor_hint()
	get_parent().global_position = map_tile_global_center
	
func move_to_tile(tile_position : Vector2i):
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	
	var target_global = layer.to_global(layer.map_to_local(tile_position))
	var displacement = target_global - get_parent().global_position
	await displace(displacement)


func move(tile_vector : Vector2i):
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	
	var target_global = layer.to_global(layer.map_to_local(map_position + tile_vector))
	var displacement = target_global - get_parent().global_position
	await displace(displacement)
	map_position = map_position + tile_vector


func displace(displacement : Vector2):
	var tween = get_parent().create_tween()
	
	if type == MovementType.Exponential:
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	await tween.tween_property(get_parent(), "global_position", get_parent().global_position + displacement, 2.0).finished


func wait(time : float = 1.0):
	await get_tree().create_timer(time).timeout


func sync_map_position():
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	
	map_position =  layer.local_to_map(layer.to_local(get_parent().global_position))



func get_map_position():
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	
	return layer.local_to_map(layer.to_local(get_parent().global_position))





"""
func correct_position():
	
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	if not map:
		return
	var layer = map.l1 as TileMapLayer
	

	var target_global_position = layer.to_global(layer.map_to_local(map_position))
	var tween = get_parent().create_tween()

	var duration = 10
	tween.tween_property(get_parent(), "global_position", target_global_position, duration)
	await tween.finished
"""
