extends Node
class_name _MushMash_CellHandler_Damager_Base

@export var health: int = 5

@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

func _input(event: InputEvent) -> void:
	pass

func _kill_cell():
	cell.queue_free()

func apply_damage(damage_amount: int):
	health = health - damage_amount
	mushmash.log.insert(0, "%s received %s damage" % [cell.name, damage_amount])
	if health <= 0:
		cell.queue_free()
		mushmash.map.on_map_cells.erase(cell)
		mushmash.map.position_indexed_cells_map[cell.map_position.y].erase(cell.map_position.x)
		
		var O_O_opponent_cells_turn_queue = []
		for c in mushmash.turner.opponent_cells_turn_queue:
			if c == cell:
				continue
			O_O_opponent_cells_turn_queue.append(c)
		mushmash.turner.opponent_cells_turn_queue = O_O_opponent_cells_turn_queue
		mushmash.log.insert(0, "%s vanquished" % [cell.name])
