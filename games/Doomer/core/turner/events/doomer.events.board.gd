extends Node
class_name _Doomer_Poker_Board_Events

@export var doomer : _Doomer
var _turn : _Doomer_Turn

var _lambda : Callable
var scene : _Doomer_Scene_Poker_Board


func field_logic():
	pass


func on_scene_start_slide_windows_in():
	scene = doomer.scene.poker_board
	_lambda = func():
		var flipper = 1
		for m : _Doomer_Message_Box in scene.all_message_boxes:
			flipper = -flipper
			if flipper > 0:
				await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
			else:
				await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromRight)
				
	doomer.turner.insert_lambda(_lambda)
	
