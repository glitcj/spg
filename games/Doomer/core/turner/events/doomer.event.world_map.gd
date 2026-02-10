extends Node
class_name _Doomer_World_Map_Events

@export var doomer : _Doomer
var _turn : _Doomer_Turn

@onready var scene : _Doomer_Scene_World_Map

func setup_map():
	# TODO: Animation events to slide in portraits and message boxes.
	pass
	
var _lambda : Callable

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
	
	# _turn = _Doomer_Turn_Lambda.new(_lambda)
	# doomer.turner.insert_turn(_turn)
