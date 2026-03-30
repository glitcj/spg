@tool
extends _Doomer_Scene
class_name _PeekaBoo

@onready var lambdas = %Lambdas as _Peekaboo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

@export var player_speed = 10
@onready var map =  %_Peekaboo_Map as _Peekaboo_Map

@onready var message_window = %"Message Window" as _Doomer_Message_Box

var scripts_stack : Array = []

func _ready() -> void:
	
	# camera = %Camera2D as Camera2D
	# accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

	if not Engine.is_editor_hint():
		_Peekaboo_Variables.initialise_variables()

func scripts_currently_on_map():
	return find_children("*", "_Peekaboo_Script")





func _on_scene_start():
	super()
	# await _Doomer_Turn_Start_Screen_Player_Input.new(doomer).start()
