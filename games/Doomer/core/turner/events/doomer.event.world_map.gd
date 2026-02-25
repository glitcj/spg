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
