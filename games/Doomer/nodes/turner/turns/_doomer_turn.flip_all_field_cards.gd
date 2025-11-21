extends _Doomer_Turn
class_name _Doomer_Turn_Flip_All_Field_Cards


var target_state : _Doomer_Card.CardState

func _init(target_state_ : _Doomer_Card.CardState = _Doomer_Card.CardState.FacingUp) -> void:
	turn_name = "Flip"
	turn_colour = Color(0.5,.3,.5)
	target_state = target_state_

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	await doomer.board.flip_all_field_cards(target_state)
	return true
	
	
		
	# TODO: _Doomer_Turn abstraction needed this will break turner loop
	# if doomer.logic.face_up_field_cards().size() < 3:
	#	turn_state_queue.insert(0, TurnStates.IdleBeforeOpponent)



func on_turn_end():
	pass
