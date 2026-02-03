extends _Doomer_Turn
class_name _Doomer_Turn_World_Map_Player_Input

enum Action {got_to_left_enemy, got_to_right_enemy}
var action : Action

var ActionMap := {
	KEY_RIGHT: Action.got_to_right_enemy,
	KEY_LEFT: Action.got_to_left_enemy,
}

var accepted_inputs = [KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

func _init() -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2
	
func on_turn_start():
	doomer.turner.turner_timer.paused = true
	doomer.handler.input_received.connect(_process_input)
	
func _process_action():
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return
	action = ActionMap[doomer.handler.input_tray]

	var _turn
	
	if action == Action.got_to_left_enemy:
		_turn = _Doomer_Turn_Change_Scene.new(_Doomer.DoomerScene.StartScreen)
		doomer.turner.turn_state_queue.insert(0, _turn)
		
	elif action == Action.got_to_right_enemy:
		
		_turn = _Doomer_Turn_Change_Scene.new(_Doomer.DoomerScene.PokerBoard)
		doomer.turner.turn_state_queue.insert(0, _turn)
		
	_interrupt_and_end_turn_end()
	
func _interrupt_and_end_turn_end():
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.turner_timer.paused = false
	queue_free()
