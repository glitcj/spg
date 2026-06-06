@tool
extends Area3D


@export_tool_button("Update") var b : Callable = _update_tilemap

func _on_button(): pass

@export var tilemap : TileMapLayer

const grid_cell_size = 1.

var grid_cell_packed_scene = preload("res://scenes/dungeon/_desert_grid_cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
			
			
func _update_tilemap():
	if not tilemap:
		push_error("No TileMapLayer assigned!")
		return

	for child in get_children():
		if child is not _Desert_Grid_Cell: continue  # don't delete the tilemap itself
		child.free()

	for cell in tilemap.get_used_cells():
		var node = grid_cell_packed_scene.instantiate() as _Desert_Grid_Cell
		node.position.x = cell.x * grid_cell_size
		node.position.z = cell.y * grid_cell_size  # TileMap Y → 3D Z
		add_child(node)
		node.owner = get_tree().edited_scene_root

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
