extends Node
class_name _PeekaBoo

@onready var logger = %"Message Box Logger" as _Doomer_Message_Box

@onready var lambdas = %Lambdas as _PeekaBoo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

@export var player_speed = 10
# @onready var player =  %Player as CharacterBody2D
@onready var map =  %Map as _Peekaboo_Map

@onready var message_window = %"Message Window" as _Doomer_Message_Box


var scripts_stack : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Peekaboo_Variables.initialise_variables()
	# update_scripts_stack()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# _on_input()
	pass

func scripts_currently_on_map():
	return find_children("*", "_Peekaboo_Script")
