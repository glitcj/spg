extends _Doomer_Turn
class_name _Doomer_Turn_World_Map_Player_Input

enum StateMachine {ShowTraits, ActiveCursor}
var state : StateMachine = StateMachine.ShowTraits
var accepted_inputs = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, KEY_ENTER, KEY_ESCAPE]

@onready var scene = doomer.scene.world_map as _Doomer_Scene_World_Map

@onready var opponents = [] as Array

func _init() -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_World_Map_Player_Input"
	turn_wait_time = .2
	
	
func on_turn_start():
	scene = doomer.scene.world_map
	await _update_portrait_animations()
	doomer.handler.input_received.connect(_process_input)
	_update_traits()
	
	
func _update_traits():
	var opponent : _Doomer_Opponent
	for i in range(scene.number_of_opponents):
		opponent = _Doomer_Opponent.new()
		opponents.append(opponent)
		
		scene.add_child(opponent)
		var _message_box = scene.trait_option_message_boxes[i] as _Doomer_Message_Box
		_message_box.show_dialogue(opponent.description())

func _process_action():
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return
	
	if state == StateMachine.ShowTraits:
		_process_input_during_show_traits()
	elif state == StateMachine.ActiveCursor:
		_process_input_during_active_cursor()
		
func _process_input_during_show_traits():
	scene.cursor.visible = true
	state = StateMachine.ActiveCursor

func _update_portrait_animations():
	var _portrait : _Doomer_Portrait
	var _lambda : Callable
	for i in range(scene.all_portraits.size()):
		_portrait = scene.all_portraits[i]
		if i == scene.cursor_index:
			_portrait.play_enumation(_Doomer_Portrait.Animations.show_in_background)
		else:
			_portrait.play_enumation(_Doomer_Portrait.Animations.hide_in_background)



func _process_input_during_active_cursor():
	if doomer.handler.input_tray == KEY_LEFT or doomer.handler.input_tray == KEY_UP:
		scene.move_cursor(
			(scene.cursor_index + 1) % scene.trait_option_containers.size()
			)
		_update_portrait_animations()
		
	elif doomer.handler.input_tray == KEY_RIGHT or doomer.handler.input_tray == KEY_DOWN:
		scene.move_cursor(
			(scene.cursor_index + 1) % scene.trait_option_containers.size()
			)
		_update_portrait_animations()
			
	elif doomer.handler.input_tray == KEY_ENTER:
		doomer.current_opponent = opponents[scene.cursor_index]

		await doomer.lambdas.buzz_message_box(
			 doomer.scene.world_map.trait_option_message_boxes[
				doomer.scene.world_map.cursor_index
				]
		).call()
		await scene.reset_cursor.call()
		await doomer.lambdas.wait(.25).call()
		await doomer.lambdas.change_scene(_Doomer.DoomerScene.PokerBoard).call()
		
		var _turn = _Doomer_Turn_Field.new()
		doomer.turner.turn_state_queue.insert(0, _turn)


		_interrupt_and_end_turn_end()
		
	elif doomer.handler.input_tray == KEY_ESCAPE:
		scene.reset_cursor()
		state = StateMachine.ShowTraits
		
		
		
func _interrupt_and_end_turn_end():
	doomer.handler.input_received.disconnect(_process_input)
	doomer.turner.start_next_turn()
	queue_free()
