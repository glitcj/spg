@tool # REQUIRED: Runs the script in the editor
extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}

@onready var parent = get_parent() as Node2D

@export var type = MovementType.Linear as MovementType
@export var steps = 50
@export var max_distance_per_step = 20.0

@export var map_position = Vector2(0, 0):
	set(v):
		map_position = v
		# Safety check: Don't run logic if we aren't inside the Tree yet
		if is_inside_tree():
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
	# 1. Get the PeekaBoo node
	var peekaboo = find_parent("_PeekaBoo")
	if not peekaboo: 
		return # Stop if we can't find the map system
	
	# 2. Access the TileMapLayer (Ensure your path to .l1 is correct)
	var tile_map_layer = peekaboo.map.l1 as TileMapLayer
	if not tile_map_layer:
		return

	# 3. Convert Map -> Local -> Global
	var local_center = tile_map_layer.map_to_local(map_position)
	var global_center = tile_map_layer.to_global(local_center)
	
	# 4. Apply to parent (checking if parent exists first)
	if parent:
		parent.global_position = global_center
	elif get_parent() is Node2D:
		get_parent().global_position = global_center

# ... rest of your movement logic ...



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




"""

@export_group("Editor Tools")
@export var snap_to_grid: bool = false:
	set(v):
		# When you click the checkbox in the Inspector, it runs this:
		_sync_map_to_actual_position()
		# We don't actually need to store 'true', so we keep it as a button trigger
		snap_to_grid = false 

# This does the REVERSE of _quantise_position
func _sync_map_to_actual_position():
	var peekaboo = find_parent("_PeekaBoo")
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
"""
