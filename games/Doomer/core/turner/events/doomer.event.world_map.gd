extends Node
class_name _Doomer_World_Map_Events

@export var doomer : _Doomer
var _turn : _Doomer_Turn

@onready var scene : _Doomer_Scene_World_Map

func setup_map():
	# TODO: Animation events to slide in portraits and message boxes.
	pass
	
var _lambda : Callable


func on_scene_start_events():
	_turn = _Doomer_Turn_World_Map_Player_Input.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	on_scene_start_slide_windows_in()
	on_scene_start_hide_faces()

func on_scene_start_slide_windows_in():
	scene = doomer.scene.world_map
	
	_lambda = func():
		var flipper = 1
		for m : _Doomer_Message_Box in scene.all_message_boxes:
			flipper = -flipper
			if flipper > 0:
				await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
			else:
				await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromRight)
				
	doomer.turner.insert_lambda(_lambda)
	
func on_scene_start_hide_faces():
	scene = doomer.scene.world_map
	_lambda = func():
		for portrait : _Doomer_Portrait in scene.all_portraits:
			portrait.play_enumation(_Doomer_Portrait.Animations.hide_in_background)
	doomer.turner.insert_lambda(_lambda)
