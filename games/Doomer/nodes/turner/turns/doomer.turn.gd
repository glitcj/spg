extends Node
class_name _Doomer_Turn

signal turn_time_finished
signal turn_interrupted_and_finished

@onready var doomer : _Doomer = get_parent().get_parent()
@onready var scene = doomer.find_child("Poker Board Scene")


var turn_name : String
var turn_colour : Color
var turn_wait_time : float = 5.0
var show_in_turnboard : bool = true

func _init() -> void:
	turn_name = "Turn"
	turn_colour = Color(1,1,1)

func _ready() -> void:
	assert(get_parent().get_parent() is _Doomer)
	if doomer:
		if doomer.turner:
			doomer.turner.turner_timer.timeout.connect(_on_turner_timer_timeout)
			
func on_turn_start():
	pass

func on_turn_end():
	queue_free()

func _on_turner_timer_timeout():
	turn_time_finished.emit()
	pass
