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

		doomer.turner.insert_turn(_Doomer_Turn_Enemy.new())

		doomer.turner.insert_turn(_Doomer_Turn_Player.new())

		doomer.turns.flip_cards(doomer.pointer.flop_cards, _Doomer_Card.CardState.FacingUp, wait_for_each_card)

		doomer.turns.show_message("Turning flop cards.", false, _Doomer_Turns.MessageType.Log)

		doomer.turns.flip_cards(doomer.pointer.player_cards, _Doomer_Card.CardState.FacingUp, wait_for_each_card)

		doomer.turns.show_message("Lets see the hand..", false, _Doomer_Turns.MessageType.Log)

		self.randomise_all_cards()


	func flip_next_card_turns():
		doomer.turner.insert_turn(_Doomer_Turn_Enemy.new())

		doomer.turner.insert_turn(_Doomer_Turn_Player.new())

		doomer.turns.show_message("Dealbring marks card ATK.", false, _Doomer_Turns.MessageType.Log)

		doomer.turns.flip_cards(doomer.pointer.next_field_card)

		doomer.turns.show_message("Flipping next card.", false, _Doomer_Turns.MessageType.Log)
		
		
	func flip_all_cards_down_turns():
		var wait_for_each_card = false

		doomer.turns.flip_cards(doomer.pointer.player_and_enemy_cards, _Doomer_Card.CardState.FacingDown, wait_for_each_card)

		doomer.turns.flip_cards(doomer.pointer.field_cards, _Doomer_Card.CardState.FacingDown, wait_for_each_card)
		
		
	func show_enemy_hand_and_winner_decision():

		doomer.turns.change_scene(_Doomer.DoomerScene.WorldMap)

		self.flip_all_cards_down_turns()

		doomer.turns.demark_cards(doomer.pointer.all_cards, _Doomer_Card.MarkPointers.all_marks, false)

		doomer.turns.change_coins(100, doomer.pointer.winner_coin_box)

		var loser_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.loser_opponent)
		
		var cards_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)

		_turn = _Doomer_Turn_Card_Attack.new(cards_pointer, loser_pointer, 10)
		doomer.turner.turn_state_queue.insert(0, _turn)

		doomer.turns.flip_cards(doomer.pointer.enemy_cards, _Doomer_Card.CardState.FacingUp, false)
		
	func randomise_all_cards():
		doomer.turns.randomise_cards(doomer.pointer.all_cards)

	func on_turn_end():
		pass
		
	func _log():
		print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
		
