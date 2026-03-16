@tool
extends Node
class_name _PeekaBoo

# @onready var logger = %"Message Box Logger" as _Doomer_Message_Box

@onready var lambdas = %Lambdas as _PeekaBoo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

@export var player_speed = 10
# @onready var player =  %Player as CharacterBody2D
@onready var map =  %Map as _Peekaboo_Map

@onready var message_window = %"Message Window" as _Doomer_Message_Box


var scripts_stack : Array = []

# Inside _PeekaBoo.gd

func _ready() -> void:
	# ONLY run the complex initialization if we are actually playing the game
	if not Engine.is_editor_hint():
		_Peekaboo_Variables.initialise_variables()
		# Any other game-start logic here
	else:
		# In the editor, just make sure we can find the map
		print("PeekaBoo: Editor mode active, skipping game initialization.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# _on_input()
	pass

func scripts_currently_on_map():
	return find_children("*", "_Peekaboo_Script")


# Add this helper function
func get_map_safe():
	if map: 
		return map
	return get_node_or_null("%Map") # Manual fetch if @onready hasn't fired
