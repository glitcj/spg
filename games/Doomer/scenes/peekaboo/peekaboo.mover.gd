# refresh
@tool # REQUIRED: Runs the script in the editor
extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}

@export var peekaboo : _PeekaBoo

@onready var parent = get_parent() as Node2D

@export var type = MovementType.Linear as MovementType
@export var steps = 50
@export var max_distance_per_step = 20.0

@export var map_position: Vector2i = Vector2i(0, 0):
	set(v):
		map_position = v
		print("Quantising from setter.")
		_quantise_position()


func _ready() -> void:
	# Ensure parent is valid in the editor
	if not parent:
		parent = get_parent() as Node2D
	
	if Engine.is_editor_hint():
		# Sync position once when the scene is opened
		_quantise_position()
		return
func _quantise_position():
	print("--- Quantise Started ---")
	
	if not is_inside_tree():
		print("FAIL: Not inside tree")
		return
		
	if not peekaboo:
		print("FAIL: Peekaboo variable is null")
		return
	
	# 1. Find the Map node
	var map_node = peekaboo.find_child("Map", true, false) 
	if not map_node:
		print("FAIL: Could not find child 'Map' inside ", peekaboo.name)
		return
	print("SUCCESS: Found Map node: ", map_node.name)

	# 2. Find the Layer (l1)
	var layer = map_node.find_child("l1", true, false) as TileMapLayer
	if not layer:
		if "l1" in map_node:
			layer = map_node.l1
			print("SUCCESS: Found l1 via property access")
			
	if not layer:
		print("FAIL: Could not find TileMapLayer 'l1'")
		return
	print("SUCCESS: Found Layer: ", layer.name)

	# 3. Calculate Position
	var grid_pos = Vector2i(map_position)
	var local_center = layer.map_to_local(grid_pos)
	var global_center = layer.to_global(local_center)
	print("CALC: Grid", grid_pos, " -> Global", global_center)
	
	# 4. Apply to Parent
	var p = get_parent()
	if not p:
		print("FAIL: Parent is null")
		return
		
	print("ATTEMPTING MOVE: Parent is ", p.name, " (Type: ", p.get_class(), ")")
	
	if p is RigidBody2D:
		p.freeze = true # Required for RigidBody to move in editor
		p.global_position = global_center
		print("MOVE COMPLETE: RigidBody2D positioned and frozen.")
	elif p is Node2D:
		p.global_position = global_center
		print("MOVE COMPLETE: Node2D positioned.")
	else:
		print("FAIL: Parent is not a Node2D/RigidBody2D")

	print("--- Quantise Finished ---")

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


func wait(time : float = 1.0):
	await get_tree().create_timer(time).timeout





@export_group("Editor Tools")
@export var snap_to_grid: bool = false:
	set(v):
		# When you click the checkbox in the Inspector, it runs this:
		_sync_map_to_actual_position()
		# We don't actually need to store 'true', so we keep it as a button trigger
		snap_to_grid = false 

# This does the REVERSE of _quantise_position
func _sync_map_to_actual_position():
	# var peekaboo = find_parent("_PeekaBoo")
	
	if not peekaboo or not is_inside_tree():
		printerr("Cannot snap: _PeekaBoo parent not found.")
		return
	
	var tile_map_layer = peekaboo.map.l1 as TileMapLayer
	var current_parent = get_parent() as Node2D
	
	if current_parent and tile_map_layer:
		# 1. Get current global position
		var global_pos = current_parent.global_position
		# 2. Convert Global -> Local -> Map Grid
		var local_pos = tile_map_layer.to_local(global_pos)
		var new_map_pos = tile_map_layer.local_to_map(local_pos)
		
		# 3. Update the exported variable (this triggers the setter)
		map_position = Vector2(new_map_pos)
		
		# 4. Force the visual snap immediately
		_quantise_position()
		print("Snapped to: ", map_position)
