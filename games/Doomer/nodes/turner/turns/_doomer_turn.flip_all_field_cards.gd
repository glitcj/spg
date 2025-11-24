extends _Doomer_Turn
class_name _Doomer_Turn_Flip_All_Field_Cards

var target_state : _Doomer_Card.CardState

func _init(target_state_ : _Doomer_Card.CardState = _Doomer_Card.CardState.FacingUp) -> void:
	turn_name = "Flip"
	turn_colour = Color(1,1,1)
	target_state = target_state_
	turn_wait_time = 2


func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	await doomer.board.flip_all_field_cards(target_state)
	return true

func on_turn_end():
	pass
