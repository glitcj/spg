extends _Doomer_Turn
class_name _Doomer_Turn_Start_Screen_Player_Input

enum Action {Continue}
var action : Action

var InputToAction := {
	KEY_UP: Action.Continue,
	KEY_RIGHT: Action.Continue,
	KEY_LEFT: Action.Continue,
	KEY_DOWN: Action.Continue,
}

var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

func _init() -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2

	
func on_turn_start():
	doomer.turner.turner_timer.paused = true
	doomer.handler.input_received.connect(_process_input)
	# await doomer.handler.input_received
	pass


func _process_action():
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return

	var _turn

	_turn = _Doomer_Turn_Field.new()
	doomer.turner.turn_state_queue.insert(0, _turn)

	doomer.turns.change_scene(_Doomer.DoomerScene.PokerBoard)
		


	_interrupt_and_end_turn_end()
	

	
func _interrupt_and_end_turn_end():
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.turner_timer.paused = false
	queue_free()
