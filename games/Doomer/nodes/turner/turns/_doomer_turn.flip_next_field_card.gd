extends _Doomer_Turn
class_name _Doomer_Turn_Flip_Next_Field_Card


func _init() -> void:
	turn_name = "Flip"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Flip_Next_Field_Card"

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	await doomer.board.flip_next_field_card()
	return
	


func on_turn_end():
	pass
