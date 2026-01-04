extends _Doomer_Turn
class_name _Doomer_Turn_Player

static var accepted_inputs = [KEY_UP, KEY_DOWN]

enum Action {Call, Check, Fold, Null}
var action : Action

var InputToAction := {
	KEY_UP: Action.Call,
	KEY_DOWN: Action.Fold,
	KEY_RIGHT: Action.Check	
}

func _init() -> void:
	turn_name = "PLY"
	turn_colour = Color(1,1,1)
	turn_wait_time = 5

func on_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.Active
	
	await doomer.handler.finished_input_mode
	action = InputToAction[doomer.handler.input_tray]
	
	_process_action()

func on_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive

func _process_action():
	if action == Action.Call:
		_on_call_action()
	if action == Action.Fold:
		_on_fold_action()
		

func _on_call_action():
	doomer.player.call_hand()
	_interrupt_and_end_turn()

func _on_fold_action():
	doomer.player.call_hand()

func _interrupt_and_end_turn():
	var wait_time = doomer.turner.turner_timer.wait_time/8
	if wait_time < doomer.turner.turner_timer.time_left:
		await get_tree().create_timer(wait_time).timeout
		doomer.turner._update_turn_state()
	
