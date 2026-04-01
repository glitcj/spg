extends _Core_Turn
class_name _Peekaboo_Turn_Player

var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

var peekaboo : _Peekaboo

func _init() -> void:
	super()
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Peekaboo_Turn_Player"
	turn_wait_time = .2


func on_turn_start():
	peekaboo = find_parent("_Peekaboo") as _Peekaboo
	
	# print(find_parent("_Peekaboo").find_child("Player"), find_parent("_Peekaboo"))
	# (find_parent("_Peekaboo").find_child("Player") as _Peekaboo_Player).is_active = true
	
	_process_input()

func _process_input():
	on_turn_end()
