extends _Doomer_Turn
class_name _Doomer_Turn_Enemy

func _init() -> void:
	turn_name = "Opponent"
	turn_colour = Color(1,1,1)

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.wait_time/8).timeout
	doomer.turner.call_hand()
	await get_tree().create_timer(doomer.turner.turner_timer.wait_time/8).timeout
	doomer.turner._update_turn_state()

func on_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive
