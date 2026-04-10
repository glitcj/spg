extends SubViewportContainer
class_name _Core_Scene

signal scene_activated
signal scene_deactivated

signal scene_started
signal scene_ended

var is_active = false:
	set(v):
		is_active = v
		if is_active:
			print(self)
			await _on_scene_activated()
		else:
			print(self)
			await _on_scene_deactivated()

# var accepted_inputs = []

@onready var doomer : _Core = find_parent("_Core")

@onready var camera : Camera2D

func _on_scene_start():
	is_active = true
	scene_activated.emit()
	scene_started.emit()
	


func _on_scene_end():
	is_active = false
	scene_deactivated.emit()
	scene_ended.emit()

"""
func _on_input_received():
	if not is_active:
		return false
	if doomer.handler.input_tray not in accepted_inputs:
		return false
	return true
"""

func is_current_scene():
	return doomer.current_scene_node == self


# de/activation is needed in cases where the scene is paused and not ended
func _on_scene_activated():
	pass

func _on_scene_deactivated():
	pass
