extends SubViewportContainer
class_name  _Doomer_Scene

signal scene_activated
signal scene_deactivated

var is_active = false
var accepted_inputs = []

@export var doomer : _Doomer

@onready var camera : Camera2D

func _on_scene_start():
	is_active = true
	scene_activated.emit()


func _on_scene_end():
	is_active = false
	scene_deactivated.emit()


func _on_input_received():
	if not is_active:
		return false
	if doomer.handler.input_tray not in accepted_inputs:
		return false
	return true


func is_current_scene():
	return doomer.current_scene_node == self
	
