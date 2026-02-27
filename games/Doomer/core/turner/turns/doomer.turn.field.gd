extends _Doomer_Turn
class_name _Doomer_Turn_Field

var _lambda : Callable

func _init(_doomer: _Doomer) -> void:
	super(_doomer)
	turn_name = "Field"
	turn_colour = Color(1,1,1)
	turn_wait_time = 0.1

func on_turn_start():
	if doomer.logic.face_up_field_cards().size() == 0:
		await start_betting_round_turns()
		# var next_field = _Doomer_Turn_Field.new(doomer)
		# next_field.start()
		# await next_field.turn_finished
		
		await _Doomer_Turn_Field.new(doomer).start()

	elif doomer.logic.face_up_field_cards().size() < 5:
		await flip_next_card_turns()
		# var next_field = _Doomer_Turn_Field.new(doomer)
		# next_field.start()
		# await next_field.turn_finished
		await _Doomer_Turn_Field.new(doomer).start()

	elif doomer.logic.face_up_field_cards().size() == 5:
		await show_enemy_hand_and_winner_decision()
		await doomer.lambdas.change_scene(_Doomer.DoomerScene.WorldMap)

	on_turn_end()

func start_betting_round_turns():
	var wait_for_each_card = false

	await doomer.board_events.randomise_cards(doomer.pointer.all_cards)
	await doomer.board_events.show_message("Lets see the hand..", false, _Doomer_Poker_Board_Events.MessageType.Log)
	await doomer.board_events.flip_cards(doomer.pointer.player_cards, _Doomer_Card.CardState.FacingUp, wait_for_each_card)
	await doomer.board_events.show_message("Turning flop cards.", false, _Doomer_Poker_Board_Events.MessageType.Log)
	await doomer.board_events.flip_cards(doomer.pointer.flop_cards, _Doomer_Card.CardState.FacingUp, wait_for_each_card)

	# var player_turn = _Doomer_Turn_Player.new(doomer)
	# player_turn.start()
	# await player_turn.turn_finished
	await _Doomer_Turn_Player.new(doomer).start()

	# var enemy_turn = _Doomer_Turn_Enemy.new(doomer)
	# enemy_turn.start()
	# await enemy_turn.turn_finished
	await _Doomer_Turn_Enemy.new(doomer).start()



func flip_next_card_turns():
	await doomer.board_events.show_message("Flipping next card.", false, _Doomer_Poker_Board_Events.MessageType.Log)
	await doomer.board_events.flip_cards(doomer.pointer.next_field_card)
	await doomer.board_events.show_message("Dealbring marks card ATK.", false, _Doomer_Poker_Board_Events.MessageType.Log)

	# var player_turn = _Doomer_Turn_Player.new(doomer)
	# player_turn.start()
	# await player_turn.turn_finished
	await _Doomer_Turn_Player.new(doomer).start()


	# var enemy_turn = _Doomer_Turn_Enemy.new(doomer)
	# enemy_turn.start()
	# await enemy_turn.turn_finished
	await _Doomer_Turn_Enemy.new(doomer).start()



func flip_all_cards_down_turns():
	var wait_for_each_card = false

	await doomer.board_events.flip_cards(doomer.pointer.field_cards, _Doomer_Card.CardState.FacingDown, wait_for_each_card)
	await doomer.board_events.flip_cards(doomer.pointer.player_and_enemy_cards, _Doomer_Card.CardState.FacingDown, wait_for_each_card)


func show_enemy_hand_and_winner_decision():

	await doomer.board_events.flip_cards(doomer.pointer.enemy_cards, _Doomer_Card.CardState.FacingUp, false)
	await doomer.board_events.card_attack(doomer.pointer.field_cards, doomer.pointer.loser_opponent, 10)
	await doomer.board_events.change_coins(100, doomer.pointer.winner_coin_box)
	await doomer.board_events.demark_cards(doomer.pointer.all_cards, _Doomer_Card.MarkPointers.all_marks, false)
	await flip_all_cards_down_turns()

	if doomer.scene.poker_board.round_counter < doomer.scene.poker_board.number_of_rounds - 1:
		_lambda = func():
			doomer.scene.poker_board.round_counter += 1
		await _lambda.call()
	else:
		_lambda = func():
			doomer.scene.poker_board.round_counter = 0
		await _lambda.call()

func randomise_all_cards():
	await doomer.board_events.randomise_cards(doomer.pointer.all_cards)

func _log():
	print("doomer.logic.face_up_field_cards().size() ", doomer.logic.face_up_field_cards().size())
