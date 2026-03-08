extends Node
class_name _Peekaboo_Variables

enum Keys {l1_1_enemies_count, l2_1_enemies_count}
static var all = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

static func initialise_variables():
	for k : Keys in Keys.values():
		all[k] = 0
