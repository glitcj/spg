@tool
extends Node2D
class_name _Peekaboo_Map

@onready var player : CharacterBody2D = %Player
@onready var l1 = %L1 as TileMapLayer
@onready var layers = find_children("L*", "TileMapLayer")

@export var quantize_all : bool:
	set(_v): _quantize_all()

@export_category("Turns")
@export var player_turn : GDScript

func _quantize_all():
	for mover in find_children("*", "_Peekaboo_Mover", true, false):
		(mover as _Peekaboo_Mover)._quantise_position()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
