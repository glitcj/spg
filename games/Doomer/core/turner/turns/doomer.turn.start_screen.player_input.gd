extends _Doomer_Turn
class_name _Doomer_Turn_Start_Screen_Player_Input

var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

var scene


func _init(_doomer: _Doomer) -> void:
	super(_doomer)
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2


func on_turn_start():
	doomer.handler.input_received.connect(_process_input)

func _process_input():
	if not doomer.handler.input_tray in accepted_inputs:
		return

	doomer.handler.input_received.disconnect(_process_input)
	await doomer.lambdas.change_scene(doomer.scene.world_map)


	on_turn_end()
