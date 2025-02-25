extends Node2D
class_name _MushMash_ActionTimerController


signal turn_timer_timeout
@onready var turn_timer = $ActionTimer

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn}
var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: 0.25,
	TurnStates.PlayerTurn: 10,
	TurnStates.IdleBeforeOpponent: 0.25,
	TurnStates.OponnentTurn: 1,
	
}

var player_cell_is_active := false
var current_turn_state := TurnStates.IdleBeforePlayer
# var current_turn_actioned := false

var player_cells_turn_queue: Array
var opponent_cells_turn_queue: Array

var current_active_cell: MushMashCell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2DActionIndicator.modulate = Color(1,0,0)
	$ActionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Timer: %s\nState: %s\nWait: %s" % [$ActionTimer.time_left, current_turn_state, $ActionTimer.wait_time]
	$TurnLabel.text = "Turn: %s" % [TurnStates.keys()[current_turn_state]]
	

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
		await _on_idle_turn_end()
		current_turn_state = TurnStates.PlayerTurn
		await _on_player_turn_start()
	elif current_turn_state == TurnStates.PlayerTurn:
		await _on_player_turn_end()
		current_turn_state = TurnStates.IdleBeforeOpponent
		await _on_idle_turn_start()
	elif current_turn_state == TurnStates.IdleBeforeOpponent:
		await _on_idle_turn_end()
		current_turn_state = TurnStates.OponnentTurn
		await _on_opponent_turn_start()
	elif current_turn_state == TurnStates.OponnentTurn:
		await _on_opponent_turn_end()
		current_turn_state = TurnStates.IdleBeforePlayer
		await _on_idle_turn_start()
	
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
	if false:
		current_active_cell.animation_player.play("ReadyForAction")
		current_active_cell.settings.is_movable = true

func _on_player_turn_end():
	if false:
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
	
	var wait_timer = get_tree().create_timer(turn_state_time_durations[TurnStates.OponnentTurn]/2)
	await wait_timer.timeout
	
	get_parent()._update_new_positions(_get_opponent_action())
	get_parent()._update_cells_map()
	

func _on_opponent_turn_end():
	current_active_cell.settings.is_movable = false
	current_active_cell.animation_player.play("RESET")	
	current_active_cell.animation_player.play("Idle")
	opponent_cells_turn_queue.append(current_active_cell)
	current_active_cell = null

func _on_idle_turn_start():
	pass

func _on_idle_turn_end():
	pass
	
func _get_opponent_action():
	return randi() % _MushMashMap.Direction.size() # _MushMashMap.Direction.Right # 0 # 
