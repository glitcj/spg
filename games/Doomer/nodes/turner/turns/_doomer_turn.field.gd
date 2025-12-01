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
		show_flop_cards_turns()

	elif doomer.logic.face_up_field_cards().size() < 5:
		flip_next_card_turns()
		
	elif doomer.logic.face_up_field_cards().size() == 5:
		flip_all_cards_down_turns()

	return
	


func start_round_turns():
	var wait_for_each_card = false
	turn_ = _Doomer_Turn_Flip_Cards.new([doomer.board.get_flop_cards()], _Doomer_Card.CardState.FacingUp, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)



func show_flop_cards_turns():
	var wait_for_each_card = false
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer_to_flop_cards()], _Doomer_Card.CardState.FacingUp, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)

func flip_next_card_turns():
	var pointer : _Doomer_Pointer = doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)
	
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Flip_Cards.new([pointer]))


func flip_all_cards_down_turns():
	var pointer 
	var wait_for_each_card = false

	
	pointer = pointer_to_field_cards()
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer], _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)

	
	pointer = pointer_to_player_and_enemy_cards()
	turn_ = _Doomer_Turn_Flip_Cards.new([pointer], _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	doomer.turner.turn_state_queue.insert(0, turn_)
	
func pointer_to_next_field_card():
	return doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)


func pointer_to_field_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)

func pointer_to_flop_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.flop_cards)
	
func pointer_to_player_and_enemy_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.player_and_enemy_cards)
	
func on_turn_end():
	pass
	
func _log():
	print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
	
