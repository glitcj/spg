extends Node
class_name _Core_Turn

signal turn_finished

var doomer : _Core
var scene : _Core_Scene

var turn_name : String
var turn_colour : Color
var turn_wait_time : float = 5.0
var show_in_turnboard : bool = true

func _init() -> void:
	# doomer = _core
	# doomer = find_parent.bind("_Core").call_deferred()
	# _boot.call_deferred()
	# scene.add_child(_scene)
	turn_name = "Turn"
	turn_colour = Color(1,1,1)

func _boot():
	pass
	

func start(_parent : Node):
	var parent = _parent
	parent.add_child(self)
	doomer = find_parent("_Core")
	
	# get_tree().add_child(self)
	on_turn_start()
	await turn_finished

func on_turn_start():
	pass

func on_turn_end():
	turn_finished.emit()
	queue_free()

func _process_input():
	pass
