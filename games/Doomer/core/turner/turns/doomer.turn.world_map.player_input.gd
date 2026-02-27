extends _Doomer_Turn
class_name _Doomer_Turn_World_Map_Player_Input

enum StateMachine {ShowTraits, ActiveCursor}
var state : StateMachine = StateMachine.ShowTraits
var accepted_inputs = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, KEY_ENTER, KEY_ESCAPE]

var scene : _Doomer_Scene_World_Map

@onready var opponents = [] as Array

func _init(_doomer: _Doomer) -> void:
	super(_doomer)
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_World_Map_Player_Input"
	turn_wait_time = .2
	
func on_turn_start():
	scene = doomer.scene.world_map
	await doomer.world_map_events.update_portrait_animations()
	doomer.handler.input_received.connect(_process_input)
	await doomer.world_map_events.create_opponents(opponents)

func _process_action():
	pass

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return

	if state == StateMachine.ShowTraits:
		scene.cursor.visible = true
		state = StateMachine.ActiveCursor
	elif state == StateMachine.ActiveCursor:
		_process_input_during_active_cursor()

func _process_input_during_active_cursor():
	if doomer.handler.input_tray == KEY_LEFT or doomer.handler.input_tray == KEY_UP:
		await doomer.world_map_events.move_cursor.bind(1).call()

	elif doomer.handler.input_tray == KEY_RIGHT or doomer.handler.input_tray == KEY_DOWN:
		await doomer.world_map_events.move_cursor.bind(1).call()

	elif doomer.handler.input_tray == KEY_ENTER:
		await doomer.world_map_events.select_opponent(opponents)
		doomer.handler.input_received.disconnect(_process_input)
		on_turn_end()

	elif doomer.handler.input_tray == KEY_ESCAPE:
		scene.reset_cursor()
		state = StateMachine.ShowTraits
