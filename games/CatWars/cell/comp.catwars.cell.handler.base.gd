extends Node
class_name _MushMash_CellHandler_Handler_Base

@onready var mushmash: _MushMash = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

enum InputModes {Inactive, Action, Move, ActionA, ActionB}
var input_mode: InputModes = InputModes.Inactive

signal input_mode_goes_to_inactive
signal input_mode_goes_to_action
signal finished_input_mode

func _input(event: InputEvent) -> void:
	if input_mode == InputModes.Inactive:
		return
	elif input_mode == InputModes.ActionA:
		cell.actioner_a._on_action_input(event)
	elif input_mode == InputModes.ActionB:
		cell.actioner_b._on_action_input(event)
	elif input_mode == InputModes.Move:
		cell.mover._on_move_input(event)

func change_input_mode(input_mode_: InputModes):
	if input_mode_ == InputModes.ActionA:
		cell.actioner_a.on_action_start()	
	elif input_mode_ == InputModes.ActionB:
		cell.actioner_b.on_action_start()
	input_mode = input_mode_
	

func _reset_handler():
	input_mode = InputModes.Inactive
	# mushmash.map.make_all_cells_immovable()
	mushmash.map.reset_idle_animation_of_all_cells()
	
func _on_action_input(event):
	pass
func _on_move_input(event):
	pass
