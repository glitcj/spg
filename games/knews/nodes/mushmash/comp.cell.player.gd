extends Node
class_name _MushMash_Player_Component

@onready var mushmash: _MushMashMap = get_parent().get_parent().get_parent().get_parent()
@onready var cell: MushMashCell = get_parent()

enum InputModes {Inactive, Action, Move}
var input_mode: InputModes = InputModes.Inactive

signal input_mode_goes_to_inactive
signal input_mode_goes_to_action

func _input(event: InputEvent) -> void:
	if input_mode == InputModes.Inactive:
		return
	elif input_mode == InputModes.Action:
		_handle_input_action(event)

func on_cell_action():
	input_mode = InputModes.Action
	input_mode_goes_to_action.emit()

func _handle_input_action(event: InputEvent):
	pass
