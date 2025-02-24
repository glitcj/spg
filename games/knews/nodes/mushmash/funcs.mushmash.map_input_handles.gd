extends Node


var cells_selector_position_x = 0
var cells_selector_position_y = 0
var cells_selected = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func input_player_turn_cells_selected(event):
	if cells_selected:
		if event.is_action_pressed("ui_right"):
			get_parent()._update_new_positions(get_parent().Direction.Right)
			get_parent()._update_cells_map()
			get_parent().turner._update_turn_state()
		elif event.is_action_pressed("ui_left"):
			get_parent()._update_new_positions(get_parent().Direction.Left)
			get_parent()._update_cells_map()
			get_parent().turner._update_turn_state()
		elif event.is_action_pressed("ui_down"):
			get_parent()._update_new_positions(get_parent().Direction.Down)
			get_parent()._update_cells_map()
			get_parent().turner._update_turn_state()
		elif event.is_action_pressed("ui_up"):
			get_parent()._update_new_positions(get_parent().Direction.Up)
			get_parent()._update_cells_map()
			get_parent().turner._update_turn_state()
		elif event.is_action_pressed("ui_accept"):
			get_parent()._update_cells_map()
			get_parent().turner._update_turn_state()


func input_player_turn_cells_to_select(event):
	assert(!cells_selected)
	if event.is_action_pressed("ui_right"):
		cells_selector_position_x += 1
		
	elif event.is_action_pressed("ui_left"):
		cells_selector_position_x -= 1

	elif event.is_action_pressed("ui_down"):
		cells_selector_position_y -= 1

	elif event.is_action_pressed("ui_up"):
		cells_selector_position_y += 1

	elif event.is_action_pressed("ui_accept"):
		cells_selected = true

func _get_selected_cells_by_x_and_y_indices(selected_x_indices: Array, selected_y_indices: Array):
	var selected_cells := []
	for cell in get_parent()._get_all_typed_cells(MushMashCellSettings.CellTypes.Player):
		if cell.settings.x in selected_x_indices and cell.settings.y in selected_y_indices:
			selected_cells.append(cell)
	return selected_cells
