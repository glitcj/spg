extends Node2D
class_name _Doomer_Turner

signal turner_timer_timeout
@onready var turn_timer = $ActionTimer
@onready var doomer: _Doomer = get_parent()

var cells_to_move_are_selectable = false

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn}
var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: .05,
	TurnStates.PlayerTurn: 5,
	TurnStates.IdleBeforeOpponent: 1,
	TurnStates.OponnentTurn: 5,
	
}

var turn_state_colours := {
	TurnStates.IdleBeforeOpponent: Color(0,1,0),
	TurnStates.OponnentTurn: Color(1,0,0),
	TurnStates.IdleBeforePlayer: Color(0,1,1),
	TurnStates.PlayerTurn: Color(0,0,1),
}

var current_turn_state
var next_turn_state
var turn_state_queue = [TurnStates.IdleBeforeOpponent, TurnStates.OponnentTurn]

var turn_queue: Array[_Doomer_Opponent] # = doomer.opponents # [doomer.player]
var current_opponent : _Doomer_Opponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionTimer.start()
	turner_timer_timeout.connect(_on_timer_timeout)

func initialise_turn_queue():	
	turn_queue = doomer.opponents

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_turn_state == null:
		return
		
	if current_opponent == null:
		return
	
	doomer.hud.turn_label.text = "Turn: %s %s" % [TurnStates.keys()[current_turn_state], current_opponent._name]

func _on_timer_timeout() -> void:
	_update_turn_state()

func _update_turn_indicator():
	doomer.hud.turn_indicator.modulate = turn_state_colours[current_turn_state]

func _update_turn_state():
	if current_turn_state != null:
		turn_state_queue.append(current_turn_state)
	current_turn_state = turn_state_queue.pop_front()
	next_turn_state = turn_state_queue[0]
	_update_turn_indicator()
	
	
	if current_turn_state == TurnStates.OponnentTurn:
		await _on_idle_turn_end()
		await _on_opponent_turn_start()
		
	elif current_turn_state == TurnStates.IdleBeforeOpponent:
		await _on_opponent_turn_end()
		await _on_idle_turn_start()



	print(current_turn_state)
	print(next_turn_state)
	print(turn_state_time_durations[next_turn_state])
	$ActionTimer.wait_time = turn_state_time_durations[current_turn_state]
	$ActionTimer.start()
	
func _initialise_player_cells_turn_queue():
	pass

func _initialise_opponent_cells_turn_queue():
	pass
	

func _on_player_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.FoldOrCall	


func _on_player_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive


func _on_enemy_turn_start():
	await get_tree().create_timer(turn_timer.time_left/2).timeout
	current_opponent.call_hand()

func _on_enemy_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive


func _on_opponent_turn_start():
	print(turn_queue)
	if turn_queue == []:
		return
	current_opponent = turn_queue.pop_front()
	print(current_opponent._name)
	
	if current_opponent.is_playable:
		_on_player_turn_start()
	else:
		_on_enemy_turn_start()
		
	# _update_turn_state()
		
		
func _on_opponent_turn_end():
	print(turn_queue)
	if current_opponent == null:
		return
		
	if current_opponent.is_playable:
		_on_player_turn_end()
	else:
		_on_enemy_turn_end()
		
	turn_queue.append(current_opponent)

func _on_idle_turn_start():
	pass

func _on_idle_turn_end():
	pass
