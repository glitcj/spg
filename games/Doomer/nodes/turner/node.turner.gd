extends Node2D
class_name _Doomer_Turner

signal turner_timer_timeout
@onready var turner_timer = $ActionTimer
@onready var doomer: _Doomer = get_parent()

var cells_to_move_are_selectable = false

enum TurnStates {IdleBeforePlayer, PlayerTurn, IdleBeforeOpponent, OponnentTurn, StartGame, EndGame}
var one_off_turn_states = [TurnStates.StartGame, TurnStates.EndGame]

var turn_state_time_durations := {
	TurnStates.IdleBeforePlayer: .05,
	TurnStates.PlayerTurn: 5,
	TurnStates.IdleBeforeOpponent: 1,
	TurnStates.OponnentTurn: 5,
	TurnStates.StartGame: 2,
	TurnStates.EndGame: 2,
}

var turn_state_colours := {
	TurnStates.IdleBeforeOpponent: Color(1,0,0),
	TurnStates.OponnentTurn: Color(0,1,0),
	TurnStates.IdleBeforePlayer: Color(0,1,1),
	TurnStates.PlayerTurn: Color(0,0,1),
	TurnStates.StartGame: Color(0,0,1),
	TurnStates.EndGame: Color(0,0,1),
}

var current_turn_state
var next_turn_state
var turn_state_queue = [TurnStates.StartGame, TurnStates.IdleBeforeOpponent, TurnStates.OponnentTurn]

var turn_queue: Array[_Doomer_Opponent] # = doomer.opponents # [doomer.player]
var current_opponent : _Doomer_Opponent
var next_opponent : _Doomer_Opponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionTimer.start()
	turner_timer_timeout.connect(_on_timer_timeout)

func initialise_turn_queue():	
	turn_queue = doomer.opponents

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	_update_turn_state()

func _update_turn_indicator():
	doomer.hud.turn_indicator.modulate = turn_state_colours[current_turn_state]

func _update_turn_state():
	if current_turn_state != null and current_turn_state not in one_off_turn_states:
		turn_state_queue.append(current_turn_state)
		
	current_turn_state = turn_state_queue.pop_front()
	next_turn_state = turn_state_queue[0]
	
	_update_turn_indicator()
	_update_hud()

	if current_turn_state == TurnStates.OponnentTurn:
		await _on_idle_turn_end()
		await _on_opponent_turn_start()
		
	elif current_turn_state == TurnStates.IdleBeforeOpponent:
		await _on_opponent_turn_end()
		await _on_idle_turn_start()
		
	elif current_turn_state == TurnStates.StartGame:
		await _on_start_game()

	$ActionTimer.wait_time = turn_state_time_durations[current_turn_state]
	$ActionTimer.start()

func _update_hud():
	next_opponent = turn_queue[0]
	if current_turn_state in [TurnStates.IdleBeforeOpponent]:
		doomer.hud.turn_label.text = "Turn: Idle" # % [TurnStates.keys()[current_turn_state]]
	elif current_turn_state in [TurnStates.OponnentTurn]:
		doomer.hud.turn_label.text = "Turn: %s" % [next_opponent._name]
	
func _on_player_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.FoldOrCall

func _on_player_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive


func _on_enemy_turn_start():
	await get_tree().create_timer(turner_timer.time_left/2).timeout
	current_opponent.call_hand()
	await get_tree().create_timer(turner_timer.time_left/4).timeout
	_update_turn_state()

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
		
func _on_opponent_turn_end():
	if current_opponent == null:
		return
		
	if current_opponent.is_playable:
		_on_player_turn_end()
	else:
		_on_enemy_turn_end()
		
	turn_queue.append(current_opponent)

func _on_idle_turn_start():
	await get_tree().create_timer(turner_timer.time_left/2).timeout
	doomer.board.flip_next_field_card()

func _on_idle_turn_end():
	pass
	
func _on_start_game():
	for opponent in doomer.opponents:
		opponent.show_cards_in_hand()

func _on_start_game_end():
	pass

func _on_end_game_start():
	pass

func _on_end_game_end():
	pass
