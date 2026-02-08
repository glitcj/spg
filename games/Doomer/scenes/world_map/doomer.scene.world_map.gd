extends _Doomer_Scene
class_name _Doomer_Scene_World_Map

@onready var enemy_trait_message_box_1 = find_child("Enemy Trait Message Box 1")
@onready var enemy_trait_message_box_2 = find_child("Enemy Trait Message Box 2")

func _ready():
	pass
	
func _on_scene_start():
	var _turn = _Doomer_Turn_World_Map_Player_Input.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	super()
