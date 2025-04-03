extends _MushMash_CellHandler_Mover_Base
class_name _MushMash_CellHandler_Mover_Mole

func _on_move_input(event: InputEvent):
	if event.is_action_pressed("ui_right", true):
		move_cell_to_direction(mushmash.map.Direction.Right)

	elif event.is_action_pressed("ui_left", true):
		move_cell_to_direction(mushmash.map.Direction.Left)

	elif event.is_action_pressed("ui_down", true):
		move_cell_to_direction(mushmash.map.Direction.Down)

	elif event.is_action_pressed("ui_up", true):
		move_cell_to_direction(mushmash.map.Direction.Up)

	elif event.is_action_pressed("ui_accept"):
		cell.handler.change_input_mode(cell.handler.InputModes.ActionA)

	elif event.is_action_pressed("mushmash_z"):
		cell.handler.change_input_mode(cell.handler.InputModes.ActionA)
		
	elif event.is_action_pressed("mushmash_x"):
		cell.handler.change_input_mode(cell.handler.InputModes.ActionB)
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if event.is_action_pressed(action, true):
			mushmash.map.mover._update_cell_to_next_position()
			mushmash.turner._update_turn_state()
			mushmash.map.make_all_cells_immovable()
			mushmash.map.reset_idle_animation_of_all_cells()
			mushmash.input_handles._reset_selector_control_variables()
			mushmash.log.insert(0, "Cat has moved to %s" % action)
			cell.handler._reset_handler()
			cell.handler.finished_input_mode.emit()

	for action in ["ui_accept", "mushmash_z", "mushmash_x"]:
		if event.is_action_pressed(action):
			cell.highlighter_animation_player.play("ReadyForActionHighlight")


func _get_on_map_cell_and_apply_damage(x, y, damage=10):
	var target_cell = mushmash.map.get_on_map_cell(x, y)

	if target_cell is MushMashCell:
		if target_cell.damager is _MushMash_CellHandler_Damager_Base:
			target_cell.damager.apply_damage(damage)


func move_cell_to_direction(direction_: _MushMash_Map.Direction):
	# cell.is_movable = true
	# mushmash.map.mover._shift_cells_next_position(mushmash._get_all_cells(), _MushMash_Map.DirectionVector[direction_])
	# cell.is_movable = false
	mushmash.map.mover._shift_cells_next_position([cell], _MushMash_Map.DirectionVector[direction_])
