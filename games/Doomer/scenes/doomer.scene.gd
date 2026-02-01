extends SubViewportContainer
class_name  _Doomer_Scene

signal scene_activated
signal scene_deactivated

var is_active = false
var accepted_inputs = []

@export var doomer : _Doomer
var scene_id : _Doomer.DoomerScene = _Doomer.DoomerScene.Null

func _on_scene_start():
	doomer.handler.input_received.connect(_on_input_received)
	is_active = true
	scene_activated.emit()


func _on_scene_end():
	doomer.handler.input_received.disconnect(_on_input_received)
	is_active = false
	scene_deactivated.emit()


func _on_input_received():
	if not is_active:
		return false
	if doomer.handler.input_tray not in accepted_inputs:
		return false
	return true
