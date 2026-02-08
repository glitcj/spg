extends _Doomer_Turn
class_name _Doomer_Turn_World_Map_Player_Input

enum Action {got_to_left_enemy, got_to_right_enemy}
var action : Action

enum StateMachine {ShowTraits, ActiveCursor}
var state : StateMachine = StateMachine.ShowTraits

var ActionMap := {
	KEY_RIGHT: Action.got_to_right_enemy,
	KEY_LEFT: Action.got_to_left_enemy,
}

var accepted_inputs = [KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

var trait_option_containers : Array
var cursor_index = 0

func _init() -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_World_Map_Player_Input"
	turn_wait_time = .2
	
func on_turn_start():
	doomer.turner.turner_timer.paused = true
	doomer.handler.input_received.connect(_process_input)
	
	trait_option_containers = [
		doomer.scene.world_map.find_child("Enemy Trait Container 1"),
		doomer.scene.world_map.find_child("Enemy Trait Container 2"),
	]
	
func _process_action():
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return
	action = ActionMap[doomer.handler.input_tray]
	
	if state == StateMachine.ShowTraits:
		_process_input_during_show_traits()
	elif state == StateMachine.ActiveCursor:
		_process_input_during_active_cursor()
		
	
func _process_input_during_show_traits():
	var cursor : AnimatedSprite2D = doomer.scene.world_map.find_child("Cursor")
	cursor.visible = true
	state = StateMachine.ActiveCursor

func _process_input_during_active_cursor():
	
	if action == Action.got_to_left_enemy:
		_move_cursor((cursor_index - 1) % trait_option_containers.size())
		
		doomer.events.change_scene(_Doomer.DoomerScene.StartScreen)
		
		doomer.events.buzz_message_box(
			doomer.scene.world_map.find_child("Enemy Trait Message Box 1")
			)
		
	elif action == Action.got_to_right_enemy:
		_move_cursor((cursor_index + 1) % trait_option_containers.size())
		
		doomer.events.change_scene(_Doomer.DoomerScene.PokerBoard)
		
		doomer.events.buzz_message_box(
			 doomer.scene.world_map.find_child("Enemy Trait Message Box 2")
		)
		
	_interrupt_and_end_turn_end()

func _interrupt_and_end_turn_end():
	_reset_cursor()
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.turner_timer.paused = false
	queue_free()


func _move_cursor(_index):
	var cursor : AnimatedSprite2D = doomer.scene.world_map.find_child("Cursor")
	
	cursor_index = _index
	cursor.reparent(trait_option_containers[cursor_index])
	cursor.position = Vector2.ZERO
	
func _reset_cursor():
	var cursor : AnimatedSprite2D = doomer.scene.world_map.find_child("Cursor")
	
	cursor.visible = false
	_move_cursor(0)
	
