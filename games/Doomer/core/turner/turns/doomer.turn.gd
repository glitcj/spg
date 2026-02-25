extends Node
class_name _Doomer_Turn

signal turn_finished

var doomer : _Doomer

var turn_name : String
var turn_colour : Color
var turn_wait_time : float = 5.0
var show_in_turnboard : bool = true

func _init(_doomer: _Doomer = null) -> void:
	doomer = _doomer
	turn_name = "Turn"
	turn_colour = Color(1,1,1)

func start():
	doomer.add_child(self)
	on_turn_start()
	await turn_finished

func on_turn_start():
	pass

func on_turn_end():
	turn_finished.emit()
	queue_free()

func _process_input():
	pass
