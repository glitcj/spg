extends Node
class_name _Doomer_Turn

@onready var doomer : _Doomer = get_parent().get_parent()
var turn_name : String
var turn_colour : Color
var turn_wait_time : float = 5.0

func _init() -> void:
	turn_name = "Turn"
	turn_colour = Color(1,1,1)

func _ready() -> void:
	assert(get_parent().get_parent() is _Doomer)

func on_turn_start():
	pass

func on_turn_end():
	pass
