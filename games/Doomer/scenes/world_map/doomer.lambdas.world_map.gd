extends Node
class_name _Doomer_World_Map_Events

@export var doomer : _Doomer
@onready var scene : _Doomer_Scene_World_Map

func on_scene_start_events():
	await on_scene_start_hide_faces()
	await on_scene_start_slide_windows_in()

func on_scene_start_slide_windows_in():
	scene = doomer.scene.world_map
	var flipper = 1
	for m : _Doomer_Message_Box in scene.all_message_boxes:
		flipper = -flipper
		if flipper > 0:
			await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
		else:
			await m.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromRight)

func on_scene_start_hide_faces():
	scene = doomer.scene.world_map
	for portrait : _Doomer_Portrait in scene.all_portraits:
		portrait.play_enumation(_Doomer_Portrait.Animations.hide_in_background)

func create_opponents(_opponents: Array):
	scene = doomer.scene.world_map
	for i in range(scene.number_of_opponents):
		var opponent = _Doomer_Opponent.new()
		_opponents.append(opponent)
		scene.add_child(opponent)
		var _message_box = scene.trait_option_message_boxes[i] as _Doomer_Message_Box
		print(_message_box, opponent.description())
		await _message_box.show_dialogue(opponent.description())

func update_portrait_animations():
	scene = doomer.scene.world_map
	for i in range(scene.all_portraits.size()):
		var _portrait = scene.all_portraits[i]
		if i == scene.cursor_index:
			_portrait.play_enumation(_Doomer_Portrait.Animations.show_in_background)
		else:
			_portrait.play_enumation(_Doomer_Portrait.Animations.hide_in_background)

func move_cursor(_direction: int):
	scene = doomer.scene.world_map
	scene.move_cursor(
		(scene.cursor_index + _direction) % scene.trait_option_containers.size()
	)
	await update_portrait_animations()

func select_opponent(_opponents: Array):
	scene = doomer.scene.world_map
	doomer.current_opponent = _opponents[scene.cursor_index]
	await doomer.lambdas.buzz_message_box(
		scene.trait_option_message_boxes[scene.cursor_index]
	).call()
	scene.reset_cursor()
	await doomer.lambdas.wait(.25).call()
	await doomer.lambdas.change_scene(_Doomer.DoomerScene.PokerBoard).call()
