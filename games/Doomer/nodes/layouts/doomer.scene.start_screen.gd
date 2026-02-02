extends _Doomer_Scene
class_name _Doomer_Scene_Start_Screen


enum Action {Continue}
var action : Action

var InputToAction := {
	KEY_UP: Action.Continue,
	KEY_RIGHT: Action.Continue,
	KEY_LEFT: Action.Continue,
	KEY_DOWN: Action.Continue,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_id = _Doomer.DoomerScene.StartScreen
	accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

func is_current_scene():
	return doomer.current_scene == _Doomer.DoomerScene.StartScreen

"""
func _on_input_received():
	super()
	doomer.change_scene(_Doomer.DoomerScene.PokerBoard)

func _on_scene_start():
	super()

func _on_scene_end():
	super()
"""
