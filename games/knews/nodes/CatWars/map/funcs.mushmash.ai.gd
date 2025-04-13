extends Node
class_name _MushMash_AI

@onready var mushmash: _MushMash = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func movable_directions_from_cell_map(x, y):
	var movable_directions = []
	var considered_cell
	for k in _MushMash_Map.Direction.keys():
		var considered_position = Vector2i(x, y)
		considered_position = considered_position + _MushMash_Map.DirectionUnitVector[_MushMash_Map.Direction[k]]

		if considered_position.x == x and considered_position.y == y:
			continue
		considered_cell = null
		if considered_position.y in mushmash.map.position_indexed_cells_map.keys() && considered_position.x in mushmash.map.position_indexed_cells_map[considered_position.y].keys():
			considered_cell =  mushmash.map.position_indexed_cells_map[considered_position.y][considered_position.x]
		if considered_cell == null and not mushmash.map.mover._is_tilemap_collision(considered_position.x, considered_position.y):
			movable_directions.append(_MushMash_Map.Direction[k])
			
	return movable_directions
