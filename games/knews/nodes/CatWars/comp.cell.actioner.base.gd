extends Node
class_name _MushMash_CellHandler_Actioner_Base

@onready var mushmash: _MushMashMap = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

enum InputModes {Inactive, Action, Move}
var input_mode: InputModes = InputModes.Inactive

signal input_mode_goes_to_inactive
signal input_mode_goes_to_action
signal finished_input_mode

func _input(event: InputEvent) -> void:
	if input_mode == InputModes.Inactive:
		return
	elif input_mode == InputModes.Action:
		_on_action_input(event)
	elif input_mode == InputModes.Move:
		_on_move_input(event)

func change_input_mode(input_mode_: InputModes):
	input_mode = input_mode_

func _reset_handler():
	input_mode = InputModes.Inactive
	mushmash.funcs.make_all_cells_immovable()
	mushmash.funcs.reset_idle_animation_of_all_cells()	
func _on_action_input(event):
	pass
func _on_move_input(event):
	pass
