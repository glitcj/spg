@tool
extends Node2D
class_name _Peekaboo_Map

@onready var player : CharacterBody2D = %Player
@onready var layers = find_children("L*", "TileMapLayer")

func get_event(_name): return find_child(_name) as _Peekaboo_Event
func get_lambdas(): return find_child("_Peekaboo_Lambdas") as _Peekaboo_Lambdas


@export var quantize_all : bool:
	set(_v): _quantize_all()

@export_category("Turns")
@export var player_turn : GDScript

func _quantize_all():
	for mover in find_children("*", "_Peekaboo_Mover", true, false):
		(mover as _Peekaboo_Mover)._quantise_position()

func scripts_currently_on_map():
	return find_children("*", "_Peekaboo_Script")
