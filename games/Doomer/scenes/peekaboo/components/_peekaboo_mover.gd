@tool
extends Node
class_name _RPGM_Mover

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
		_quantise_position()

func get_map(): return find_parent("_RPGM_Map") as _RPGM_Map

var is_moving = false
func _ready() -> void:
	if true or Engine.is_editor_hint():
		
		# Fixes conflict between _Map and _Mover
		# Refactor both
		await get_tree().process_frame

		_quantise_position()

func _quantise_position():
	if not is_inside_tree():
		return
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	var map_tile_global_center = base_layer.to_global(base_layer.map_to_local(map_position))
	
	get_parent().global_position = map_tile_global_center
	
func move_to_tile_2(tile_position : Vector2i):
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	var target_global = base_layer.to_global(base_layer.map_to_local(tile_position))
	var displacement = target_global - get_parent().global_position
	await displace(displacement)


func move(tile_vector : Vector2i) -> _RPGM_Mover:
	var base_layer = get_map().find_child("L1 Base") as TileMapLayer
	
	var target_global = base_layer.to_global(base_layer.map_to_local(map_position + tile_vector))
	var displacement = target_global - get_parent().global_position
	
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
		
func tile_has_collision(tile_pos: Vector2i) -> bool:
	for layer : TileMapLayer in get_map().layers:
		var tile_data = layer.get_cell_tile_data(tile_pos)
		
		if tile_data == null:
			continue
	
		if tile_data.get_collision_polygons_count(0) > 0:
			return true
	return false

# Refactor _Mover
# Refactor _Map

# Refactor common events ? have event root extend script directly ?
# No have it extend _RPGM_Event and simple var exports and setters as a built in script in the event root
# Setters set the vars of component children for easy tree access
# And add common script as a components
# And saved as e.g. _common_event_teleport.tscn

# Refactor rooms ? npcs as children of rooms ?
