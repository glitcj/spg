@tool
extends Node2D
class_name _RPGM_Map

@onready var player : CharacterBody2D = %Player
@onready var layers = find_children("L*", "TileMapLayer")

func get_event(_name): return find_child(_name) as _RPGM_Event
func find_event(_name): return find_child(_name) as _RPGM_Event
func get_lambdas(): return find_child("_RPGM_Lambdas") as _RPGM_Lambdas


@export_tool_button("Quantise All") var quantise_all_callable : Callable = _quantise_all
	
func _ready() -> void:
	if false: print_tree_pretty()
	
func _quantise_all():
	for mover in find_children("*", "_RPGM_Mover", true, false):
		(mover as _RPGM_Mover)._quantise_position()

func scripts_currently_on_map():
	return find_children("*", "_RPGM_Script")
