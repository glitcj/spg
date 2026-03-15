extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}
enum StateMachine {Moving, Stopped}

@onready var parent = get_parent() as Node2D
var destination = Vector2.ZERO as Vector2
@export var displacement = Vector2.ZERO as Vector2

@export var type = MovementType.Linear as MovementType
@export var steps = 50
@export var max_distance_per_step = 20.0



@export var map_position = Vector2(0, 0) as Vector2:
	set(v):
		map_position = v
		_quantise_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is Node2D)
	return
	destination = parent.position



func wait(time : float = 1.0):
	await get_tree().create_timer(time).timeout

func move(_displacement : Vector2):
	
	var tween = get_parent().create_tween()
	if type == MovementType.Exponential:
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
	var duration = 2
	
	## tween.tween_callback(func(): parent.position = Vector2(0, 0))
	## tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 1))
	
	
	## tween.tween_property(parent, "modulate", Color(1,0,1,1), duration)

	
	tween.parallel().tween_property(parent, "position", parent.position + _displacement, duration)
	
	await tween.finished
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	return

func _move_linearly():
	return


func _move_exponentially():
	return



"""
func _update_positions():
	var peekaboo = find_parent("_PeekaBoo") as _PeekaBoo
	var local_pos = peekaboo.map.l1.map_to_local(tile_position)
	var global_pos = peekaboo.map.l1.to_global(local_pos)
	get_parent().global_position = peekaboo.map.l1.to_global(local_pos)
"""

func move_to_tile(tile_position : Vector2):
	
	var peekaboo = find_parent("_PeekaBoo") as _PeekaBoo
	var local_pos = peekaboo.map.l1.map_to_local(tile_position)
	var global_pos = peekaboo.map.l1.to_global(local_pos)
	
	print(local_pos, global_pos, global_pos - get_parent().global_position)
	var _displacement = global_pos - get_parent().global_position as Vector2
	

	await move(_displacement)
	
	
	# move(global_pos - get_parent().global_position)
	# move(displacement)

func tiles_travelled(tile_position):
	pass
	
func _update_map_position():
	var peekaboo = find_parent("_PeekaBoo") as _PeekaBoo

	# Get the global position of the node
	var global_pos = parent.global_position
	
	var tile_map_layer = peekaboo.map.l1 as TileMapLayer

	# 1. Convert Global to the TileMap's Local space
	var local_pos = tile_map_layer.to_local(global_pos)

	# 2. Convert Local space to Grid coordinates (e.g., Vector2i(5, 3))
	# var map_pos = tile_map_layer.local_to_map(local_pos)
	map_position = tile_map_layer.local_to_map(local_pos)

func _quantise_position():
	var peekaboo = find_parent("_PeekaBoo") as _PeekaBoo
	var tile_map_layer = peekaboo.map.l1 as TileMapLayer
	
	# 1. Take the grid coordinate (Vector2i) and get its Local center
	var local_center = tile_map_layer.map_to_local(map_position)
	
	# 2. Convert that Local center to a Global position
	var global_center = tile_map_layer.to_global(local_center)
	
	# 3. Apply it to your node
	parent.global_position = global_center
