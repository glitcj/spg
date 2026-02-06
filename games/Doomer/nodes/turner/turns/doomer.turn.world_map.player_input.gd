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
	name = "_Doomer_Turn_World_Map_Player_Input"
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

	var _turn : _Doomer_Turn
	var _message_box : _Doomer_Message_Box
	
	if action == Action.got_to_left_enemy:
		doomer.events.change_scene(_Doomer.DoomerScene.StartScreen)
		
		_message_box = doomer.scene.world_map.find_child("Enemy Trait Message Box 1")
		doomer.events.buzz_message_box(_message_box)
		
	elif action == Action.got_to_right_enemy:
		doomer.events.change_scene(_Doomer.DoomerScene.PokerBoard)
		
		_message_box = doomer.scene.world_map.find_child("Enemy Trait Message Box 2")
		doomer.events.buzz_message_box(_message_box)
		
	_interrupt_and_end_turn_end()
	
func _interrupt_and_end_turn_end():
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.turner_timer.paused = false
	queue_free()
