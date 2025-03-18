extends _MushMash_CellHandler_Mover_Base
# class_name _MushMash_CellHandler_Mover_Base_Mole
class_name _MushMash_CellHandler_Mover_Mole

func _on_action_input(event):
	if event.is_action_pressed("ui_right"):
		mushmash.map.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Right)

	elif event.is_action_pressed("ui_left"):
		mushmash.map.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Left)

	elif event.is_action_pressed("ui_down"):
		mushmash.map.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Down)

	elif event.is_action_pressed("ui_up"):
		mushmash.map.resolve_damage_and_cell_placement()
		mushmash._update_new_positions(mushmash.Direction.Up)
		
		var target_cell = mushmash.map.get_on_map_cell(cell.x, cell.y + 1)
		if target_cell is MushMashCell:
			apply_damage(target_cell)
		

	elif event.is_action_pressed("ui_accept"):
		pass
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]:
		if event.is_action_pressed(action):
			cell.action_animation_player.play("Rotator")
			mushmash._update_cells_map()
			mushmash.map.make_all_cells_immovable()
			mushmash.map.reset_idle_animation_of_all_cells()
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
			mushmash.map.make_all_cells_immovable()
			mushmash.map.reset_idle_animation_of_all_cells()
			mushmash.input_handles._reset_selector_control_variables()
			_reset_handler()
			finished_input_mode.emit()

	for action in ["ui_accept"]:
		if event.is_action_pressed(action):
			cell.highlighter_animation_player.play("ReadyForActionHighlight")



func apply_damage(target_cell_: MushMashCell):
	if target_cell_.damager is _MushMash_CellHandler_Damager_Base:
		pass
	pass



# Replace _Mushmash position updater, move resolve collisions
"""
func _update_cell_position(direction: int):
	if true:
		print("\n\n----- Old Maps ------")
		print_cells_map()
		print_uuid_map()	
		pass
		
		var x = 0
	
	for cell in _get_all_cells():
		if not cell.is_movable:
			continue
			
		var i = cell.x
		var j = cell.y
		

		if direction == Direction.Down:
			_update_single_cell(cell, i, j + 1)

		elif direction == Direction.Up:
			_update_single_cell(cell, i, j - 1)
			
		elif direction == Direction.Left:
			_update_single_cell(cell, i - 1, j)
			
		elif direction == Direction.Right:
			_update_single_cell(cell, i + 1, j)

	_resolve_cell_collisions()
"""
