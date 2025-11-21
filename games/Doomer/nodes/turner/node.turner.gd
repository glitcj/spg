extends Node2D
class_name _Doomer_Turner

signal turner_timer_timeout
@onready var turner_timer: Timer = $ActionTimer
@onready var doomer: _Doomer = get_parent()

var last_turn_state : _Doomer_Turn
var current_turn_state : _Doomer_Turn
var next_turn_state : _Doomer_Turn


var processed_turns : Array[_Doomer_Turn] = []
var turn_state_queue = [_Doomer_Turn_Start_Game.new()] # , _Doomer_Turn_Field.new(), _Doomer_Turn_End_Game.new()]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionTimer.start()
	turner_timer_timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	doomer.hud.hourglass.gauge = (turner_timer.time_left/turner_timer.wait_time)/ 0.2

func _on_timer_timeout() -> void:
	_update_turn_state()

func _update_turn_indicator():
	doomer.hud.turn_indicator.modulate = current_turn_state.turn_colour

func _update_turn_state():
	if current_turn_state != null:
		last_turn_state = current_turn_state
		processed_turns.append(current_turn_state)
		remove_child(last_turn_state)
		
	if turn_state_queue == []:
		turn_state_queue.append(_Doomer_Turn_End_Game.new())
	
	current_turn_state = turn_state_queue.pop_front()
	add_child(current_turn_state)
	
	if not turn_state_queue == []:
		next_turn_state = turn_state_queue[0]

	_update_hud()
	
	
	print("current_turn_state.turn_wait_time ", current_turn_state.turn_wait_time)
	$ActionTimer.wait_time = current_turn_state.turn_wait_time
	$ActionTimer.start()
	
	if last_turn_state != null:
		await last_turn_state.on_turn_end()
	await current_turn_state.on_turn_start()

func _update_hud():
	_update_turn_indicator()
	doomer.hud.turn_label.text = "Turn: %s" % [current_turn_state.turn_name]
