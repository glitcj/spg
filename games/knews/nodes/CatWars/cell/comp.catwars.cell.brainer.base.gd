extends Node
class_name _MushMash_CellHandler_Brainer_Base

@export var health: int = 5
@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

func _input(event: InputEvent) -> void:
	pass

func _kill_cell():
	cell.queue_free()

func apply_damage(damage_amount: int):
	health = health - damage_amount
	if health <= 0:
		cell.queue_free()
		mushmash.cells_map[cell.y].erase(cell.x)
		
		var O_O_opponent_cells_turn_queue = []
		for c in mushmash.turner.opponent_cells_turn_queue:
			if c == cell:
				continue
			O_O_opponent_cells_turn_queue.append(c)
		mushmash.turner.opponent_cells_turn_queue = O_O_opponent_cells_turn_queue
				
		print("AFTER QUEUEFREE")
	
func _get_opponent_action():
	var movable_directions : Array = mushmash.ai.movable_directions_from_cell_map(cell.x, cell.y)
	print(movable_directions)
	if movable_directions == []:
		return 0
	return movable_directions[randi() % movable_directions.size()]
