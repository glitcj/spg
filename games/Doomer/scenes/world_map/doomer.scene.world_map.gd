extends _Doomer_Scene
class_name _Doomer_Scene_World_Map

@onready var cursor = %Cursor as AnimatedSprite2D

var cursor_index = 0
var number_of_opponents = 2
	
@onready var trait_option_containers := [
	%"Enemy Trait Container 1",
	%"Enemy Trait Container 2"
]

@onready var trait_option_message_boxes := [
	%"Enemy Trait Message Box 1",
	%"Enemy Trait Message Box 2"
]

func _ready():
	pass
	
func _on_scene_start():
	var _turn = _Doomer_Turn_World_Map_Player_Input.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	super()

func move_cursor(_index):	
	cursor_index = _index
	cursor.reparent(trait_option_containers[cursor_index])
	cursor.position = Vector2.ZERO
	
func reset_cursor():
	cursor.visible = false
	move_cursor(0)
