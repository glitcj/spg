extends Node
class_name _MushMash_CellHandler_Brainer_Base

@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

func _input(event: InputEvent) -> void:
	pass

func _kill_cell():
	cell.queue_free()

func get_opponent_action():
	var movable_directions : Array = mushmash.ai.movable_directions_from_cell_map(cell.map_position.x, cell.map_position.y)
	print(movable_directions)
	if movable_directions == []:
		return 0
	return movable_directions[randi() % movable_directions.size()]

func perform_opponent_action():
	var action = get_opponent_action()
	cell.mover.move_cell_to_direction(action)
	mushmash.log.insert(0, "%s has moved to %s" % [cell.name, action])
