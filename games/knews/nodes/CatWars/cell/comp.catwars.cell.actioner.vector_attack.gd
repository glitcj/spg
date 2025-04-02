extends _MushMash_CellHandler_Actioner_Base
class_name _MushMash_CellHandler_Actioner_VectorAttack


func _on_action_input(event):
	if event.is_action_pressed("ui_right"):
		attack_normal(cell.map_position.x+1, cell.y)
		cell.mover.move_cell_to_direction(mushmash.Direction.Right)

	elif event.is_action_pressed("ui_left"):
		attack_normal(cell.map_position.x - 1, cell.y)
		cell.mover.move_cell_to_direction(mushmash.Direction.Left)
		
	elif event.is_action_pressed("ui_down"):
		attack_normal(cell.map_position.x, cell.y+1)
		cell.mover.move_cell_to_direction(mushmash.Direction.Down)
		
	elif event.is_action_pressed("ui_up"):
		attack_normal(cell.map_position.x, cell.y-1)
		cell.mover.move_cell_to_direction(mushmash.Direction.Up)

	elif event.is_action_pressed("ui_accept"):
		pass
		
	for action in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]:
		if event.is_action_pressed(action):
			cell.action_animation_player.play("Rotator")
			cell.action_animation_player.queue("RESET")
			mushmash._update_cells_map()
			mushmash.map.make_all_cells_immovable()
			mushmash.map.reset_idle_animation_of_all_cells()
			mushmash.input_handles._reset_selector_control_variables()
			await cell.action_animation_player.animation_finished
			
			mushmash.turner._update_turn_state()
			cell.handler._reset_handler()
			cell.handler.finished_input_mode.emit()


func on_action_start():
	var all_movable_cells = []
	for direction in _MushMash.Direction:
		print(direction, _MushMash.Direction[direction])
		for p in mushmash.map.get_movable_vector(Vector2i(cell.map_position.x, cell.map_position.y), _MushMash.Direction[direction]):
			all_movable_cells.append(p)
	
	var tiles_to_highlight = []
	var tile
	mushmash.map.change_highlighted_tiles(all_movable_cells)
	
func attack_normal(x, y):
	cell.mover._get_on_map_cell_and_apply_damage(x, y)
	mushmash.map.resolve_damage_and_cell_placement()
	mushmash.map.clear_highlighted_tiles()
