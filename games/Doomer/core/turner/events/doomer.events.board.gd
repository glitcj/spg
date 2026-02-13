extends Node
class_name _Doomer_Poker_Board_Events


@export var doomer : _Doomer
var _turn : _Doomer_Turn

var _lambda : Callable
var scene : _Doomer_Scene_Poker_Board

func field_logic():
	pass

func on_scene_start_events():
	scene = doomer.scene.poker_board
	scene.enemy_traits_message_box.show_dialogue(doomer.current_opponent.description())
	
	scene.animation_player.play("slide_board_in")
	await scene.animation_player.animation_finished
	
	await on_scene_start_slide_windows_in_as_lambda()

# Queue Event
func on_scene_start_slide_windows_in():
	scene = doomer.scene.poker_board
	var flipper = 1
	for m : _Doomer_Message_Box in scene.all_message_boxes:
		flipper = -flipper
		if flipper > 0:
			await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
		else:
			await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromRight)

# Queue Event
func on_scene_start_slide_windows_in_as_lambda():
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
	
