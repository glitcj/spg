extends _MushMash_CellHandler_Actioner_Base
class_name _MushMash_CellHandler_Actioner_VectorAttack

var directional_button_to_position: Dictionary
var vector_tray: Dictionary

func _on_action_input(event: InputEvent):
	if CommonFunctions.get_first_input_event_name(event) == null:
		pass
	elif CommonFunctions.get_first_input_event_name(event) == "ui_accept":
		pass
	else:
		var pressed_direction = _MushMash_Map.InputToDirection[CommonFunctions.get_first_input_event_name(event)]
		var attack_vector = vector_tray[pressed_direction]
		print(pressed_direction, attack_vector)
		if not mushmash.map.mover.is_cell_collision(attack_vector[-1]):
			for position_: Vector2i in attack_vector:
				attack_normal(position_)
			mushmash.map.mover._change_cells_next_position([cell], directional_button_to_position[pressed_direction])

	if CommonFunctions.get_first_input_event_name(event) in ["ui_up", "ui_down", "ui_left", "ui_right", "ui_accept"]:
		cell.action_animation_player.play("Rotator")
		cell.action_animation_player.queue("RESET")
		mushmash.map.mover._update_all_cells_to_next_position()
		mushmash.map.reset_idle_animation_of_all_cells()
		mushmash.map.clear_highlighted_tiles()
		mushmash.input_handles._reset_selector_control_variables()
		await cell.action_animation_player.animation_finished
		
		mushmash.turner._update_turn_state()
		cell.handler._reset_handler()
		cell.handler.finished_input_mode.emit()

func on_action_start():
	var all_movable_tiles = []
	vector_tray = {}
	
	for direction in _MushMash_Map.Direction:
		vector_tray[_MushMash_Map.Direction[direction]] = []
		print(direction, _MushMash_Map.Direction[direction])
		for p: Vector2i in mushmash.map.mover.get_movable_vector(cell.map_position, _MushMash_Map.Direction[direction]):
			all_movable_tiles.append(p)
			vector_tray[_MushMash_Map.Direction[direction]].append(p)
	
	mushmash.map.clear_highlighted_tiles()
	for direction in vector_tray.keys():
		var vector_positions = vector_tray[direction]
		print(vector_tray, vector_positions)
		if _vector_is_movable(vector_positions):
			mushmash.map.change_highlighted_tiles(vector_positions, Color.AZURE)
		else:
			mushmash.map.change_highlighted_tiles(vector_positions, Color.RED)
		
	directional_button_to_position = {
		_MushMash_Map.Direction.Up: cell.map_position,
		_MushMash_Map.Direction.Down: cell.map_position,
		_MushMash_Map.Direction.Left: cell.map_position,
		_MushMash_Map.Direction.Right: cell.map_position,
	}
	
	for v in all_movable_tiles:
		if v.y < directional_button_to_position[_MushMash_Map.Direction.Up].y:
			directional_button_to_position[_MushMash_Map.Direction.Up] = v
		if v.y > directional_button_to_position[_MushMash_Map.Direction.Down].y:
			directional_button_to_position[_MushMash_Map.Direction.Down] = v
		if v.x < directional_button_to_position[_MushMash_Map.Direction.Left].x:
			directional_button_to_position[_MushMash_Map.Direction.Left] = v
		if v.x > directional_button_to_position[_MushMash_Map.Direction.Right].x:
			directional_button_to_position[_MushMash_Map.Direction.Right] = v
	
			
func attack_normal(position_: Vector2i):
	cell.mover._get_on_map_cell_and_apply_damage(position_.x, position_.y)
	mushmash.map.resolve_damage_and_cell_placement()

func _vector_is_movable(movement_vector_: Array):
	return movement_vector_ != [] && not mushmash.map.mover.is_cell_collision(movement_vector_[-1])
