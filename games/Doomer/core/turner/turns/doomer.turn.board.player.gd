extends _Doomer_Turn
class_name _Doomer_Turn_Player

static var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT]

enum Action {Call, Check, Fold, Null}
var action : Action

var action_placed_and_performed : bool = false
var interrupt_buffer_wait_time : float = _Doomer_Constants.immediate_action_time_delta

var scene : _Doomer_Scene_Poker_Board

enum StateMachine {ShowingBoard, ShowingTraits, ShowingPlayerHand}

var state : StateMachine = StateMachine.ShowingBoard

func _init(_doomer: _Doomer) -> void:
	super(_doomer)
	turn_name = "PLY"
	turn_colour = Color(1,1,1)
	turn_wait_time = 200

func on_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.Active
	await doomer.handler.finished_input_mode

	doomer.handler.input_received.connect(_on_input_received)

func on_turn_end():
	if doomer.handler.input_received.is_connected(_on_input_received):
		doomer.handler.input_received.disconnect(_on_input_received)
	if not action_placed_and_performed:
		await _on_fold_action()
	super()

func _interrupt_and_end_turn():
	doomer.handler.input_received.disconnect(_on_input_received)
	await get_tree().create_timer(interrupt_buffer_wait_time).timeout
	on_turn_end()

func _process_action_while_showing_board():

	if doomer.handler.input_tray == KEY_UP:
		await _on_call_action()
	elif doomer.handler.input_tray == KEY_DOWN:
		await _on_fold_action()
	elif doomer.handler.input_tray == KEY_RIGHT:
		await _on_show_traits_action()
		state = StateMachine.ShowingTraits
	elif doomer.handler.input_tray == KEY_LEFT:
		await _on_show_player_hand_action()
		state = StateMachine.ShowingPlayerHand

	var performed_call_or_fold_action = doomer.handler.input_tray in [KEY_UP, KEY_DOWN]
	if performed_call_or_fold_action:
		action_placed_and_performed = true
		_interrupt_and_end_turn()

func _process_action_while_showing_traits():
	if doomer.handler.input_tray == KEY_LEFT:
		await _on_hide_traits_action()
		state = StateMachine.ShowingBoard


func _process_action_while_showing_hand():
	if doomer.handler.input_tray == KEY_RIGHT:
		await _on_hide_player_hand_action()
		state = StateMachine.ShowingBoard


func _on_show_traits_action():
	scene = doomer.scene.poker_board
	await scene.enemy_traits_message_box.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)


func _on_show_player_hand_action():
	scene = doomer.scene.poker_board
	await scene.player_hand_message_box.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromRight)


func _on_hide_player_hand_action():
	scene = doomer.scene.poker_board
	await scene.player_hand_message_box.play_enumation(_Doomer_Message_Box.Enumations.SlideOutToRight)


func _on_hide_traits_action():
	scene = doomer.scene.poker_board
	await scene.enemy_traits_message_box.play_enumation(_Doomer_Message_Box.Enumations.SlideOutToLeft)


func _on_input_received():
	if doomer.handler.input_tray not in accepted_inputs:
		return false
	if state == StateMachine.ShowingBoard:
		_process_action_while_showing_board()
	elif state == StateMachine.ShowingTraits:
		_process_action_while_showing_traits()
	elif state == StateMachine.ShowingPlayerHand:
		_process_action_while_showing_hand()


func _on_call_action():
	var _portrait : _Doomer_Portrait = doomer.pointer.player_portrait()
	_portrait.play_enumation_queue([_Doomer_Portrait.Animations.Attack, _Doomer_Portrait.Animations.RESET, _Doomer_Portrait.Animations.Idle], false)

	var cards = doomer.pointer.cards_ready_to_bet_by_player()
	var mark_type = _Doomer_Card_Mark.MarkType.ATK

	for card : _Doomer_Card in cards:
		card.add_mark(mark_type, _Doomer.Opponents.Player)

func _on_fold_action():
	var _portrait : _Doomer_Portrait = doomer.pointer.player_portrait()
	_portrait.play_enumation_queue([_Doomer_Portrait.Animations.Damage, _Doomer_Portrait.Animations.RESET,  _Doomer_Portrait.Animations.Idle], false)

	var cards = doomer.pointer.cards_ready_to_bet_by_player()
	var mark_type = _Doomer_Card_Mark.MarkType.DEF

	for card : _Doomer_Card in cards:
		card.add_mark(mark_type, _Doomer.Opponents.Player)
