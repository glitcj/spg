extends Node
class_name _MushMash_CellHandler_Actioner_Base

@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

func _on_action_input(event):
	pass

func on_action_start():
	pass
