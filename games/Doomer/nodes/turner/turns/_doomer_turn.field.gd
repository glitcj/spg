extends _Doomer_Turn
class_name _Doomer_Turn_Field

func _init() -> void:
	turn_name = "Field"
	turn_colour = Color(1,1,1)
	turn_wait_time = .2
	# name = "_Doomer_Turn_Field"

func on_turn_start():
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Field.new())
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	
	if doomer.logic.face_up_field_cards().size() < 3:
		print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
		for i in range(3 - doomer.logic.face_up_field_cards().size()):
			print("doomer.turner.turn_state_queue. ", doomer.turner.turn_state_queue)
			doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Flip_Next_Field_Card.new())
		
	elif doomer.logic.face_up_field_cards().size() < 5:
		doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Flip_Next_Field_Card.new())
		
	elif doomer.logic.face_up_field_cards().size() == 5:
		var turn_ 
		turn_ = _Doomer_Turn_Flip_All_Field_Cards.new()
		turn_._init(_Doomer_Card.CardState.FacingDown)
		doomer.turner.turn_state_queue.insert(0, turn_)
		
		# We can also do this, since _init maps to .new
		# turn_ = _Doomer_Turn_Flip_Cards.new(doomer.get_player_and_opponent_cards())
		
		turn_ = _Doomer_Turn_Flip_Cards.new()
		turn_._init(doomer.get_player_and_opponent_cards())
	
	return
	
	

func on_turn_end():
	pass
