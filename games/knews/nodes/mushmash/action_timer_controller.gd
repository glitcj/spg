extends Node2D
class_name _MushMash_ActionTimerController


signal turn_timer_timeout
@onready var turn_timer = $ActionTimer

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn}
var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: .05,
	TurnStates.PlayerTurn: 3,
	TurnStates.IdleBeforeOpponent: 0.05,
	TurnStates.OponnentTurn: 1,
	
}

var player_cell_is_active := false
var current_turn_state := TurnStates.IdleBeforePlayer
var current_turn_actioned := false

var player_cells_turn_queue: Array
var opponent_cells_turn_queue: Array

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
		
	if current_turn_state == TurnStates.IdleBeforeOpponent:
		$Sprite2DActionIndicator.modulate = Color(0,0,1)
		
	if current_turn_state == TurnStates.OponnentTurn:
		$Sprite2DActionIndicator.modulate = Color(0,1,1)

func _update_turn_state():
	if current_turn_state == TurnStates.IdleBeforePlayer:
		_on_idle_turn_end()
		current_turn_state = TurnStates.PlayerTurn
		_on_player_turn_start()
	elif current_turn_state == TurnStates.PlayerTurn:
		_on_player_turn_end()
		current_turn_state = TurnStates.IdleBeforeOpponent
		_on_idle_turn_start()
	elif current_turn_state == TurnStates.IdleBeforeOpponent:
		_on_idle_turn_end()
		current_turn_state = TurnStates.OponnentTurn
		_on_opponent_turn_start()
	elif current_turn_state == TurnStates.OponnentTurn:
		_on_opponent_turn_end()
		current_turn_state = TurnStates.IdleBeforePlayer
		_on_idle_turn_start()
	
	# Restart Timer
	$ActionTimer.wait_time = turn_state_time_durations[current_turn_state]
	$ActionTimer.start()
	
	_update_turn_indicator()

	
func _initialise_player_cells_turn_queue():
	player_cells_turn_queue = get_parent()._get_all_typed_cells([MushMashCellSettings.CellTypes.Player])

func _initialise_opponent_cells_turn_queue():
	opponent_cells_turn_queue = get_parent()._get_all_typed_cells([MushMashCellSettings.CellTypes.Oponnent])
	

func _on_player_turn_start():
	current_active_cell = player_cells_turn_queue.pop_front()
	current_active_cell.animation_player.play("ReadyForAction")
	current_active_cell.settings.is_movable = true

func _on_player_turn_end():
	current_active_cell.settings.is_movable = false
	current_active_cell.animation_player.play("RESET")
	await current_active_cell.animation_player.animation_finished
	current_active_cell.animation_player.play("Idle")
	player_cells_turn_queue.append(current_active_cell)
	current_active_cell = null
	
func _on_opponent_turn_start():
	current_active_cell = opponent_cells_turn_queue.pop_front()
	current_active_cell.animation_player.play("ReadyForAction")
	current_active_cell.settings.is_movable = true
	
	
	# var O_O_: Timer = Timer.new()
	# O_O_.wait_time = turn_state_time_durations[TurnStates.OponnentTurn]/2
	# O_O_.start()
	# await O_O_.timeout
	

	var wait_timer = get_tree().create_timer(turn_state_time_durations[TurnStates.OponnentTurn]/2)
	await wait_timer.timeout
	
	push_error(current_active_cell)

	get_parent()._update_new_positions(0)
	get_parent()._update_cells_map()
	# $Turner._update_turn_state()
	
	push_error(current_active_cell)
	pass

	
	
	
func _on_opponent_turn_end():
	current_active_cell.settings.is_movable = false
	current_active_cell.animation_player.play("RESET")
	await current_active_cell.animation_player.animation_finished
	

	current_active_cell.animation_player.play("Idle")
	
	opponent_cells_turn_queue.append(current_active_cell)
	current_active_cell = null




func _on_idle_turn_start():
	pass



func _on_idle_turn_end():
	pass
