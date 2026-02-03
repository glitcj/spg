extends _Doomer_Turn
class_name _Doomer_Turn_Lambda


var to_call : Callable
var to_bind : Array
var wait_amount : float = .2

func _init(to_call_ : Callable, to_bind_ : Array = []) -> void:
	turn_name = "LMD"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Lambda"
	turn_wait_time = .2
	
	to_call = to_call_
	to_bind = to_bind_
	
func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	# TODO: Deep loop through to_bind if you runtime variables are needed
	to_call.bind(to_bind).call()
	
	
func on_turn_end():
	doomer.turner.turner_timer.paused = false
	super()
