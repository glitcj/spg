extends Node
class_name _Doomer_Turner

@onready var doomer: _Doomer = get_parent()

var last_turn_state : _Doomer_Turn
var current_turn_state : _Doomer_Turn
var next_turn_state : _Doomer_Turn


var processed_turns : Array[_Doomer_Turn] = []
var turn_state_queue = []


func _ready() -> void:
	turn_state_queue = [_Doomer_Turn_Lambda.new(doomer.change_scene, [_Doomer.DoomerScene.StartScreen])]
	call_deferred("start_next_turn")

# Stub kept because doomer.turner.tscn connects ActionTimer.timeout to this method.
func _on_timer_timeout() -> void:
	pass


func _update_turn_indicator():
	pass

func start_next_turn():
	if current_turn_state != null:
		last_turn_state = current_turn_state
		processed_turns.append(current_turn_state)
		remove_child(last_turn_state)

	if turn_state_queue == []:
		return

	current_turn_state = turn_state_queue.pop_front()
	add_child(current_turn_state)

	if not turn_state_queue == []:
		next_turn_state = turn_state_queue[0]

	# if current_turn_state == null:
	# 	return

	print("current_turn_state.turn_wait_time ", current_turn_state.turn_wait_time)


	if last_turn_state != null:
		await last_turn_state.on_turn_end()
		if last_turn_state.show_in_turnboard:
			doomer.hud.message_box.message_portrait.play_enumation(_Doomer_Portrait.Animations.BoardOut)

		
	if current_turn_state.show_in_turnboard:
		doomer.hud.message_box.message_portrait.turnboard_turn_name = "%s" % [current_turn_state.turn_name]
		doomer.hud.message_box.message_portrait.play_enumation(_Doomer_Portrait.Animations.BoardIn)
	await current_turn_state.on_turn_start()

func _update_hud():
	if not current_turn_state.show_in_turnboard:
		return

func _on_scene_activated():
	pass

func _on_scene_deactivated():
	pass
	
func insert_turn(_turn : _Doomer_Turn, _position = 0):
	turn_state_queue.insert(_position, _turn)

func insert_lambda(_callable : Callable):
	insert_turn(_Doomer_Turn_Lambda.new(_callable))
