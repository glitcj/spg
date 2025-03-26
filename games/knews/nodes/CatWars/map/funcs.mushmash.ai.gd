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
	var considered_position_y
	var considered_position_x
	var considered_cell
	for k in get_parent().Direction.keys():
		considered_position_y = y
		considered_position_x = x
		if get_parent().Direction[k] == get_parent().Direction.Right:
			considered_position_x = x + 1
		elif get_parent().Direction[k] == get_parent().Direction.Left:
			considered_position_x = x - 1
		elif get_parent().Direction[k] == get_parent().Direction.Up:
			considered_position_y = y - 1
		elif get_parent().Direction[k] == get_parent().Direction.Down:
			considered_position_y = y + 1
			
		if considered_position_x == x and considered_position_y == y:
			continue
		considered_cell = null
		if considered_position_y in get_parent().cells_map.keys() && considered_position_x in get_parent().cells_map[considered_position_y].keys():
			considered_cell =  get_parent().cells_map[considered_position_y][considered_position_x]
		if considered_cell == null and not mushmash.map._is_tilemap_collision(considered_position_x, considered_position_y):
			movable_directions.append(get_parent().Direction[k])
			
	return movable_directions
