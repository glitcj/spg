extends _MushMash_CellInputHandler
class_name _MushMash_CellInputHandler_Mole

func _on_action_input(event):
	if event.is_action_pressed("ui_right"):
		mushmash.funcs.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Right)

	elif event.is_action_pressed("ui_left"):
		mushmash.funcs.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Left)

	elif event.is_action_pressed("ui_down"):
		mushmash.funcs.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Down)

	elif event.is_action_pressed("ui_up"):
		mushmash.funcs.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Up)

	elif event.is_action_pressed("ui_accept"):
		pass
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]:
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

	for action in ["ui_accept"]:
		if event.is_action_pressed(action):
			cell.highlighter_animation_player.play("ReadyForActionHighlight")
