extends _Doomer_Turn
class_name _Doomer_Turn_Field

@onready var turns : Turns = Turns.new(doomer)

func _init() -> void:
	turn_name = "Field"
	turn_colour = Color(1,1,1)
	turn_wait_time = 0.1
	
func on_turn_start():
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Field.new())
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	
	if doomer.logic.face_up_field_cards().size() == 0:
		turns.start_betting_round_turns()
	
	elif doomer.logic.face_up_field_cards().size() < 5:
		turns.flip_next_card_turns()
		
	elif doomer.logic.face_up_field_cards().size() == 5:
		turns.show_enemy_hand_and_winner_decision()

	return
	

class Turns:
	var doomer : _Doomer
	var turn_ # TODO: deprecate
	var pointer # TODO: deprecate
	var _pointer
	var _turn
	var message
	var message_type
	
	func _init(doomer_):
		doomer = doomer_
		
	func start_betting_round_turns():
		var wait_for_each_card = false

		_turn = _Doomer_Turn_Enemy.new()
		doomer.turner.turn_state_queue.insert(0, _turn)

		_turn = _Doomer_Turn_Player.new()
		doomer.turner.turn_state_queue.insert(0, _turn)

		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.flop_cards)
		doomer.turns.flip_cards(pointer, _Doomer_Card.CardState.FacingUp, wait_for_each_card)

		doomer.turns.show_message("Turning flop cards.", false, _Doomer_Turns.MessageType.Log, null)

		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.player_cards)
		doomer.turns.flip_cards(pointer, _Doomer_Card.CardState.FacingUp, wait_for_each_card)

		doomer.turns.show_message("Lets see the hand..", false, _Doomer_Turns.MessageType.Log, null)

		self.randomise_all_cards()


	func flip_next_card_turns():
		_turn = _Doomer_Turn_Enemy.new()
		doomer.turner.turn_state_queue.insert(0, _turn)

		_turn = _Doomer_Turn_Player.new()
		doomer.turner.turn_state_queue.insert(0, _turn)

		doomer.turns.show_message("Dealbring marks card ATK.", false, _Doomer_Turns.MessageType.Log, null)

		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)
		doomer.turns.flip_cards(pointer)

		doomer.turns.show_message("Flipping next card.", false, _Doomer_Turns.MessageType.Log, null)
		
		
	func flip_all_cards_down_turns():
		var wait_for_each_card = false

		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.player_and_enemy_cards)
		doomer.turns.flip_cards(pointer, _Doomer_Card.CardState.FacingDown, wait_for_each_card)

		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)
		doomer.turns.flip_cards(pointer, _Doomer_Card.CardState.FacingDown, wait_for_each_card)
		
		
	func show_enemy_hand_and_winner_decision():

		doomer.turns.change_scene(_Doomer.DoomerScene.WorldMap)

		self.flip_all_cards_down_turns()

		var cards_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.all_cards)
		var marks_pointer = _Doomer_Card.MarkPointers.all_marks
		doomer.turns.demark_cards(cards_pointer, marks_pointer, false)

		_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.winner_coin_box)
		doomer.turns.change_coins(100, _pointer)

		var loser_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.loser_opponent)
		cards_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)
		_turn = _Doomer_Turn_Card_Attack.new(cards_pointer, loser_pointer, 10)
		doomer.turner.turn_state_queue.insert(0, _turn)

		var wait_for_each_card = false
		_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.enemy_cards)
		doomer.turns.flip_cards(_pointer, _Doomer_Card.CardState.FacingUp, wait_for_each_card)
		
	func randomise_all_cards():
		pointer = doomer.make_pointer(_Doomer_Pointer.Keys.all_cards)
		doomer.turns.randomise_cards(pointer)

	func on_turn_end():
		pass
		
	func _log():
		print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
		
