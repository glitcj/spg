extends _Doomer_Turn
class_name _Doomer_Turn_Field

var turn_ : _Doomer_Turn 

func _init() -> void:
	turn_name = "Field"
	turn_colour = Color(1,1,1)
	turn_wait_time = .2
	# name = "_Doomer_Turn_Field"

func on_turn_start():
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Field.new())
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	
	if doomer.logic.face_up_field_cards().size() < 3:
		_log()
		update_turns_to_show_field_starter_cards()

	elif doomer.logic.face_up_field_cards().size() < 5:
		update_turns_to_flip_next_card()
		
	elif doomer.logic.face_up_field_cards().size() == 5:
		flip_all_cards_down()

	return
	

func update_turns_to_show_field_starter_cards():
	
	var to_prepend = []
	for i in range(3):
		turn_ = _Doomer_Turn_Flip_Cards.new([doomer.board.get_field_cards()[i]], _Doomer_Card.CardState.FacingUp)
		to_prepend.append(turn_)
	
	while to_prepend.size() > 0:
		doomer.turner.turn_state_queue.insert(0, to_prepend.pop_back())

func update_turns_to_flip_next_card():
	var pointer : _Doomer_Pointer = doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)
	
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Flip_Cards.new([pointer]))


func flip_all_cards_down():
	var pointer 
	var wait_for_each_card = false
	
	pointer = pointer_to_player_and_opponent_cards()
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer], _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)
	
	pointer = pointer_to_field_cards()
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer], _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)
	
	pointer = pointer_to_field_cards()
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer], _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)


func pointer_to_next_field_card():
	return doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)

func pointer_to_player_and_opponent_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.player_and_opponent_cards)

func pointer_to_field_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)

func on_turn_end():
	pass

func _log():
	print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
	
