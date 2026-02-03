extends _Doomer_Scene
class_name _Doomer_Scene_World_Map

func _ready():
	pass
	
func _on_scene_start():
	var _turn = _Doomer_Turn_World_Map_Player_Input.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	super()
