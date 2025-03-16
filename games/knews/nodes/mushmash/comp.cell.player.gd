extends Node
class_name _MushMash_CellInputHandler

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

func _on_action_input(event):
	if event.is_action_pressed("ui_right"):
		mushmash._update_new_positions(mushmash.Direction.Right)

	elif event.is_action_pressed("ui_left"):
		mushmash._update_new_positions(mushmash.Direction.Left)

	elif event.is_action_pressed("ui_down"):
		mushmash._update_new_positions(mushmash.Direction.Down)

	elif event.is_action_pressed("ui_up"):
		mushmash._update_new_positions(mushmash.Direction.Up)

	elif event.is_action_pressed("ui_accept"):
		pass
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept]"]:
		if event.is_action_pressed(action):
			cell.action_animation_player.play("Rotator")
			mushmash._update_cells_map()
			mushmash.funcs.make_all_cells_immovable()
			mushmash.funcs.reset_idle_animation_of_all_cells()
			mushmash.input_handles._reset_selector_control_variables()
			await cell.action_animation_player.animation_finished
			mushmash.turner._update_turn_state()
			_reset_handler()
			finished_input_mode.emit()

func _on_move_input(event):
	if event.is_action_pressed("ui_right"):
		mushmash._update_new_positions(mushmash.Direction.Right)

	elif event.is_action_pressed("ui_left"):
		mushmash._update_new_positions(mushmash.Direction.Left)

	elif event.is_action_pressed("ui_down"):
		mushmash._update_new_positions(mushmash.Direction.Down)

	elif event.is_action_pressed("ui_up"):
		mushmash._update_new_positions(mushmash.Direction.Up)

	elif event.is_action_pressed("ui_accept"):
		change_input_mode(InputModes.Action)
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if event.is_action_pressed(action):
			mushmash._update_cells_map()
			mushmash.turner._update_turn_state()
			mushmash.funcs.make_all_cells_immovable()
			mushmash.funcs.reset_idle_animation_of_all_cells()
			mushmash.input_handles._reset_selector_control_variables()
			_reset_handler()
			finished_input_mode.emit()



func _reset_handler():
	input_mode = InputModes.Inactive
