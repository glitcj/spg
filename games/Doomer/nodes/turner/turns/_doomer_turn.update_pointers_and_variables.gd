extends _Doomer_Turn
class_name _Doomer_Turn_Update_Pointers_And_Variables

var turn_ : _Doomer_Turn 

func _init() -> void:
	turn_name = "Field"
	turn_colour = Color(1,1,1)
	turn_wait_time = .2
	# name = "_Doomer_Update_Pointers_And_Variables"

func on_turn_start():
	doomer.pointers.update_pointers_and_variables()
	

func on_turn_end():
	pass
