extends Node
class_name _MushMash_Map_Handler

var cells_selector_position_x = 0
var cells_selector_position_y = 0
var cells_selected = false


enum InputModes {Inactive, SelectCell, MoveMovableCells}
signal finished_input_mode

var mode = InputModes.Inactive
var tray = null
var last_selected_cells


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_inputs(event):
	pass
	if mode == InputModes.Inactive:
		return
	elif mode == InputModes.SelectCell:
		input_player_turn_cells_to_select(event)

func get_from_input_mode(mode_):
	mode = mode_

func input_player_turn_cells_to_select(event):
	assert(!cells_selected)
	
	if event.is_action_pressed("ui_accept"):
		cells_selected = true
		print(cells_selector_position_x, cells_selector_position_y, range(get_parent().settings.width), cells_selected)
		mode = InputModes.Inactive
		tray = last_selected_cells
		finished_input_mode.emit()
		

	else:
		if event.is_action_pressed("ui_right"):
			cells_selector_position_x += 1
			
		elif event.is_action_pressed("ui_left"):
			cells_selector_position_x -= 1

		elif event.is_action_pressed("ui_down"):
			cells_selector_position_y += 1

		elif event.is_action_pressed("ui_up"):
			cells_selector_position_y -= 1
			
		for action in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if event.is_action_pressed(action):
				cells_selector_position_x = range(get_parent().settings.width)[cells_selector_position_x % get_parent().settings.width]
				cells_selector_position_y = range(get_parent().settings.height)[cells_selector_position_y % get_parent().settings.height]
				
				if action in ["ui_up", "ui_down"]:
					last_selected_cells = _update_cell_selection_indicator(range(get_parent().settings.width), [cells_selector_position_y])
				if action in ["ui_left", "ui_right"]:
					last_selected_cells = _update_cell_selection_indicator([cells_selector_position_x], range(get_parent().settings.height))

func _update_cell_selection_indicator(selected_x_indices: Array, selected_y_indices: Array):
	
	var playable_cells : Array = get_parent()._get_all_typed_cells([MushMashCell.CellTypes.Player])
	var selected_cells := []
	for cell in playable_cells:
		if cell.map_position.x in selected_x_indices and cell.map_position.y in selected_y_indices:
			selected_cells.append(cell)
	
	for cell: MushMashCell in playable_cells:
		if cell in selected_cells:
			cell.animation_player.play("ReadyForAction")
			cell.is_movable = true
		else:
			cell.animation_player.play("RESET")
			cell.animation_player.queue("Idle")
			cell.is_movable = false

	return selected_cells


func _reset_selector_control_variables():
	cells_selector_position_x = 0
	cells_selector_position_y = 0
	cells_selected = false

func reset():
	_reset_selector_control_variables
	get_parent().map.make_all_cells_immovable()
	get_parent().map.reset_idle_animation_of_all_cells()
	
