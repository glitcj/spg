extends _Doomer_Turn
class_name _Doomer_Turn_Start_Screen_Player_Input

var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

@onready var scene = doomer.find_child("Poker Board Scene")


func _init() -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2

	
func on_turn_start():
	doomer.turner.turner_timer.paused = true
	doomer.handler.input_received.connect(_process_input)
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return
	var _turn

	_turn = _Doomer_Turn_Field.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	
	doomer.events.change_scene(_Doomer.DoomerScene.WorldMap)
	
	_interrupt_and_end_turn_end()
	

	
func _interrupt_and_end_turn_end():
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.turner_timer.paused = false
	queue_free()
