extends _Doomer_Turn
class_name _Doomer_Turn_Player

static var accepted_inputs = [KEY_UP, KEY_DOWN]

enum Action {Call, Check, Fold, Null}
var action : Action

var action_placed_and_performed : bool = false
var interrupt_buffer_wait_time : float = _Doomer_Constants.imeddiate_action_time_delta

var ActionMap := {
	KEY_UP: Action.Call,
	KEY_DOWN: Action.Fold,
}

func _init() -> void:
	turn_name = "PLY"
	turn_colour = Color(1,1,1)
	turn_wait_time = 200

func on_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.Active
	await doomer.handler.finished_input_mode
	
	doomer.turner.turner_timer.paused = true
	doomer.handler.input_received.connect(_on_input_received)

func on_turn_end():
	doomer.handler.input_received.disconnect(_process_action)
	if not action_placed_and_performed:
		await _on_fold_action()
	super()

func _process_action():
	action = ActionMap[doomer.handler.input_tray]

	if action == Action.Call:
		await _on_call_action()
	elif action == Action.Fold:
		await _on_fold_action()
	action_placed_and_performed = true
	_interrupt_and_end_turn()

func _on_input_received():
	if doomer.handler.input_tray not in accepted_inputs:
		return false
	_process_action()


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
	

func _interrupt_and_end_turn():
	doomer.handler.input_received.disconnect(_process_action)
	
	await get_tree().create_timer(interrupt_buffer_wait_time).timeout
	doomer.turner.turner_timer.paused = false
	doomer.turner._update_turn_state()
