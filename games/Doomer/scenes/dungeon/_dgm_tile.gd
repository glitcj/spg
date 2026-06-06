@tool
extends Node3D
class_name _DGM_Tile

# Assign a Callable (lambda) to run your function when clicked
@export_tool_button("print tree") var p = func(): _print_tree_pretty()

func _print_tree_pretty(): 
	print_tree_pretty()

@export_enum("floor","wall","event") var type = "floor":
	set(value):
		type = value
		_update_cell()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _update_cell():
	# Reset states before applying new ones to avoid stacking bugs
	%"StaticBody3D Wall".visible = false
	%"CollisionShape3D Wall".disabled = true
	
	if type == "floor": 
		pass
	if type == "wall": 
		%"StaticBody3D Wall".visible = true
		%"CollisionShape3D Wall".disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
