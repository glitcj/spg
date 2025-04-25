extends Node2D
class_name _Poke_Turner

signal turn_timer_timeout
@onready var turn_timer = $ActionTimer

@onready var doomer: _Poke = get_parent()

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

# var current_active_cell: doomerCell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# doomer.hud.turn_indicator.modulate = Color(1,0,0)
	$ActionTimer.start()
	turn_timer_timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_turn_state == null:
		return
	
	# doomer.hud.turn_label.text = "Timer: %0.2f\nState: %s\nWait: %s" % [$ActionTimer.time_left, current_turn_state, $ActionTimer.wait_time]
	# doomer.hud.timer_label.text = "Timer: %0.2f" % $ActionTimer.time_left # \nState: %s" % [$ActionTimer.time_left, current_turn_state]
	doomer.hud.turn_label.text = "Turn: %s" % [TurnStates.keys()[current_turn_state]]

func _on_timer_timeout() -> void:
	_update_turn_state()
	
func _update_turn_indicator():
	if current_turn_state == TurnStates.IdleBeforePlayer:
		doomer.hud.turn_indicator.modulate = Color(0,1,0)
		
	if current_turn_state == TurnStates.PlayerTurn:
		doomer.hud.turn_indicator.modulate = Color(1,0,0)
		
	if current_turn_state == TurnStates.IdleBeforeOpponent:
		doomer.hud.turn_indicator.modulate = Color(0,0,1)
		
	if current_turn_state == TurnStates.OponnentTurn:
		doomer.hud.turn_indicator.modulate = Color(0,1,1)

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
	# player_cells_turn_queue = get_parent()._get_all_typed_cells([doomerCell.CellTypes.Player])
	player_cells_turn_queue = []

func _initialise_opponent_cells_turn_queue():
	# opponent_cells_turn_queue = get_parent()._get_all_typed_cells([doomerCell.CellTypes.Oponnent])
	opponent_cells_turn_queue = []
	

func _on_player_turn_start():
	pass

func _on_player_turn_end():
	pass

func _on_opponent_turn_start():
	if opponent_cells_turn_queue == []:
		return

func _on_opponent_turn_end():
	pass
	
func _on_idle_turn_start():
	pass

func _on_idle_turn_end():
	pass
	
func _get_opponent_action(cell):
	pass
