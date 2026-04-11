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
			scene_activated.emit()
			await _on_scene_activated()
		else:
			print(self)
			scene_deactivated.emit()
			await _on_scene_deactivated()

@onready var doomer : _Core = find_parent("_Core")
@onready var camera : Camera2D

func _on_scene_start():
	await get_tree().process_frame
	is_active = true
	scene_started.emit()

	
func _on_scene_end():
	await get_tree().process_frame

	is_active = false
	scene_ended.emit()


func is_current_scene():
	return doomer.current_scene_node == self


# de/activation is needed in cases where the scene is paused and not ended
func _on_scene_activated():
	pass

func _on_scene_deactivated():
	pass
