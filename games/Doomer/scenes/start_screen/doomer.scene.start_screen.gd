extends _Doomer_Scene
class_name _Doomer_Scene_Start_Screen

@export var player_turn : Script

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
	camera = %Camera2D as Camera2D
	scene_id = _Doomer.DoomerScene.StartScreen
	accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
	scene_id = _Doomer.DoomerScene.StartScreen


func _on_scene_start():
	super()
	await _Doomer_Turn_Start_Screen_Player_Input.new(doomer).start()
