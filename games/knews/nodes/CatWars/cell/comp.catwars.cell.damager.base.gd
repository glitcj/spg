extends Node
class_name _MushMash_CellHandler_Damager_Base

@export var health: int

@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

func _input(event: InputEvent) -> void:
	pass

func _kill_cell():
	cell.queue_free()

func apply_damage(damage_amount: int):
	health = health - damage_amount
