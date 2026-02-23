extends _Doomer_Scene
class_name _Doomer_Scene_World_Map


@onready var cursor = %Cursor as AnimatedSprite2D
@onready var guide_message_box = %"Guide Message Box" as _Doomer_Message_Box

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

@onready var all_message_boxes := [
	%"Guide Message Box",
	%"Enemy Trait Message Box 1",
	%"Enemy Trait Message Box 2"
]

@onready var all_portraits := [
	%"Enemy Portrait 1",
	%"Enemy Portrait 2"
]

func _ready():
	camera = %Camera2D as Camera2D
	pass
	
func _on_scene_start():
	doomer.world_map_events.on_scene_start_events()	
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
