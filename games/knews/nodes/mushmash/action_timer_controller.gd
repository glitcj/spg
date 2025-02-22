extends Node2D
class_name _MushMash_ActionTimerController


signal turn_timer_timeout
@onready var turn_timer = $ActionTimer

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn}
var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: 1,
	TurnStates.PlayerTurn: 3,
	TurnStates.IdleBeforeOpponent: 0.5,
	TurnStates.OponnentTurn: 0.5,
	
}

var player_cell_is_active := false
var current_turn_state := TurnStates.IdleBeforePlayer
var current_turn_actioned := false
var cells_turn_queue: Array
var current_active_cell: MushMashCell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Can replace IDE signal connection
	# $ActionTimer.timeout.connect(_on_timer_timeout)

	$Sprite2DActionIndicator.modulate = Color(1,0,0)
	$ActionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Timer: %s\nState: %s\nWait: %s" % [$ActionTimer.time_left, current_turn_state, $ActionTimer.wait_time]
	
	pass


func _on_timer_timeout() -> void:
	_update_turn_state()
	
func _update_turn_indicator():
	if current_turn_state == TurnStates.IdleBeforePlayer:
		$Sprite2DActionIndicator.modulate = Color(0,1,0)
		
	if current_turn_state == TurnStates.PlayerTurn:
		$Sprite2DActionIndicator.modulate = Color(1,0,0)

func _update_turn_state():
	if current_turn_state == TurnStates.IdleBeforePlayer:
		current_turn_state = TurnStates.PlayerTurn
		_start_next_turn()
	elif current_turn_state == TurnStates.PlayerTurn:
		current_turn_state = TurnStates.IdleBeforePlayer
		_end_current_turn()
	
	# Restart Timer
	$ActionTimer.wait_time = turn_state_time_durations[current_turn_state]
	$ActionTimer.start()
	
	_update_turn_indicator()

	
func _update_cells_turn_queue():
	cells_turn_queue = get_parent()._get_all_cells()

func _initialise_cells_turn_queue():
	# cells_turn_queue = _get_all_cells()
	cells_turn_queue = get_parent()._get_all_typed_cells([MushMashCellSettings.CellTypes.Player])
	
func _start_next_turn():
	current_active_cell = cells_turn_queue.pop_front()
	current_active_cell.animation_player.play("ReadyForAction")
	current_active_cell.settings.is_movable = true
	# current_turn_actioned = false

	
func _end_current_turn():
	current_active_cell.settings.is_movable = false
	current_active_cell.animation_player.play("RESET")
	await current_active_cell.animation_player.animation_finished
	current_active_cell.animation_player.play("Idle")
	cells_turn_queue.append(current_active_cell)
	current_active_cell = null
	# current_turn_actioned = true
	# _update_turn_state()
