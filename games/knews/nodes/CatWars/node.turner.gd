extends Node2D
class_name _MushMash_Turner

signal turn_timer_timeout
@onready var turn_timer = $ActionTimer

@onready var mushmash: _MushMash = get_parent()

var cells_to_move_are_selectable = false

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn}
var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: .05,
	TurnStates.PlayerTurn: 5,
	TurnStates.IdleBeforeOpponent: .05,
	TurnStates.OponnentTurn: .1,
	
}

var player_cell_is_active := false
var current_turn_state
var next_turn_state

var turn_state_queue = [TurnStates.IdleBeforePlayer, TurnStates.PlayerTurn, TurnStates.IdleBeforeOpponent, TurnStates.OponnentTurn]

var player_cells_turn_queue: Array
var opponent_cells_turn_queue: Array

var current_active_cell: MushMashCell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2DActionIndicator.modulate = Color(1,0,0)
	$ActionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_turn_state == null:
		return
	# $Label.text = "Timer: %s\nState: %s\nWait: %s" % [$ActionTimer.time_left, current_turn_state, $ActionTimer.wait_time]
	# $TurnLabel.text = "Turn: %s" % [TurnStates.keys()[current_turn_state]]
	mushmash.hud.turn_label.text = "Timer: %s\nState: %s\nWait: %s" % [$ActionTimer.time_left, current_turn_state, $ActionTimer.wait_time]
	mushmash.hud.turn_label.text += "\nTurn: %s" % [TurnStates.keys()[current_turn_state]]

func _on_timer_timeout() -> void:
	_update_turn_state()
	
func _update_turn_indicator():
	if current_turn_state == TurnStates.IdleBeforePlayer:
		$Sprite2DActionIndicator.modulate = Color(0,1,0)
		
	if current_turn_state == TurnStates.PlayerTurn:
		$Sprite2DActionIndicator.modulate = Color(1,0,0)
		
	if current_turn_state == TurnStates.IdleBeforeOpponent:
		$Sprite2DActionIndicator.modulate = Color(0,0,1)
		
	if current_turn_state == TurnStates.OponnentTurn:
		$Sprite2DActionIndicator.modulate = Color(0,1,1)

func _update_turn_state():
	if current_turn_state != null:
		turn_state_queue.append(current_turn_state)
	current_turn_state = turn_state_queue.pop_front()
	next_turn_state = turn_state_queue[0]
	_update_turn_indicator()
	
	if current_turn_state == TurnStates.IdleBeforePlayer:
		await _on_opponent_turn_end()
		await _on_idle_turn_start()
		

	elif current_turn_state == TurnStates.PlayerTurn:
		await _on_idle_turn_end()
		_on_player_turn_start()
		
	elif current_turn_state == TurnStates.IdleBeforeOpponent:
		_on_player_turn_end()
		await _on_idle_turn_start()

	elif current_turn_state == TurnStates.OponnentTurn:
		await _on_idle_turn_end()
		await _on_opponent_turn_start()

	print(current_turn_state)
	print(next_turn_state)
	print(turn_state_time_durations[next_turn_state])
	$ActionTimer.wait_time = turn_state_time_durations[current_turn_state]
	$ActionTimer.start()
	


func _initialise_player_cells_turn_queue():
	player_cells_turn_queue = get_parent()._get_all_typed_cells([MushMashCell.CellTypes.Player])

func _initialise_opponent_cells_turn_queue():
	opponent_cells_turn_queue = get_parent()._get_all_typed_cells([MushMashCell.CellTypes.Oponnent])
	

func _on_player_turn_start():
	
	# mushmash.constants
	if cells_to_move_are_selectable:
		var input_handler : _MushMash_InputHandles = get_parent().input_handles
		current_active_cell = player_cells_turn_queue.pop_front()
		input_handler.get_from_input_mode(input_handler.InputModes.SelectCell)
		
		await input_handler.finished_input_mode
		var selected_cells: Array = input_handler.tray
		
		input_handler.get_from_input_mode(input_handler.InputModes.MoveMovableCells)
		await input_handler.finished_input_mode

	else:
		current_active_cell = player_cells_turn_queue.pop_front()
		# mushmash.camera.position = current_active_cell.position
		current_active_cell.highlighter_animation_player.play("RESET")
		current_active_cell.highlighter_animation_player.queue("ActiveCellHighlight")
		get_parent().map.update_hud_face(current_active_cell.face_sheets[current_active_cell.cell_sprite])
		
		current_active_cell.is_movable = true
		current_active_cell.mover.change_input_mode(_MushMash_CellHandler_Mover_Base.InputModes.Move)
		
		await current_active_cell.mover.finished_input_mode


func _on_player_turn_end():
	current_active_cell.mover._reset_handler()
	current_active_cell.highlighter_animation_player.play("RESET")
	
	if player_cells_turn_queue != []:
		var next_active_player_cell: MushMashCell = player_cells_turn_queue[0]
		next_active_player_cell.highlighter_animation_player.play("NextCellHighlight")
	
	player_cells_turn_queue.append(current_active_cell)
	current_active_cell = null
	
func _on_opponent_turn_start():
	if opponent_cells_turn_queue == []:
		return
	current_active_cell = opponent_cells_turn_queue.pop_front()
	current_active_cell.highlighter_animation_player.play("ActiveCellHighlight")
	current_active_cell.is_movable = true
	get_parent().map.update_hud_face(current_active_cell.face_sheets[current_active_cell.cell_sprite])
	
	print("AAA", current_active_cell)
	var wait_timer = get_tree().create_timer(turn_state_time_durations[TurnStates.OponnentTurn]/2)
	await wait_timer.timeout
	
	print("BBB", current_active_cell)
	print(current_active_cell.type)
	get_parent()._update_new_positions(mushmash._get_all_cells(), _get_opponent_action(current_active_cell))
	# get_parent()._update_new_positions(_get_opponent_action(current_active_cell))
	
	get_parent()._update_cells_map()
	

func _on_opponent_turn_end():
	if current_active_cell == null:
		return
	current_active_cell.is_movable = false
	current_active_cell.animation_player.play("RESET")	
	current_active_cell.animation_player.queue("Idle")
	current_active_cell.highlighter_animation_player.play("RESET")
	opponent_cells_turn_queue.append(current_active_cell)
	current_active_cell = null

func _on_idle_turn_start():
	pass

func _on_idle_turn_end():
	pass
	
func _get_opponent_action(cell: MushMashCell):
	var movable_directions : Array = get_parent().ai.movable_directions_from_cell_map(cell.x, cell.y)
	print(movable_directions)
	if movable_directions == []:
		return 0
	return movable_directions[randi() % movable_directions.size()]
