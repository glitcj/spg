extends _Doomer_Scene
class_name _Doomer_Scene_World_Map



# static var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

enum Action {got_to_left_enemy, got_to_right_enemy}
var action : Action

var ActionMap := {
	KEY_RIGHT: Action.got_to_right_enemy,
	KEY_LEFT: Action.got_to_left_enemy,
}


func _ready():
	accepted_inputs = [KEY_LEFT, KEY_RIGHT]
	
func _on_input_received():
	if not super():
		return
	action = ActionMap[doomer.handler.input_tray]
	if action == Action.got_to_left_enemy:		
		doomer.change_scene(_Doomer.DoomerScene.StartScreen)
	if action == Action.got_to_right_enemy:		
		doomer.change_scene(_Doomer.DoomerScene.PokerBoard)
