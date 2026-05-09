extends SubViewportContainer
class_name _Core_Viewport

signal activated
signal deactivated

signal started
signal finished

var is_active = false:
	set(v):
		is_active = v
		if is_active:
			print(self)
			 # we do not connect, because signal_activated must be emitted AFTER activation is complete
			await _activate()
			activated.emit()

		else:
			print(self)
			await _deactivate()
			deactivated.emit()


@onready var core : _Core = find_parent("_Core")
@onready var camera : Camera2D

func _on_scene_start():
	print(self, get_parent(), get_parent().get_parent())
	await get_tree().process_frame
	is_active = true
	started.emit()

	
func _on_scene_end():
	await get_tree().process_frame

	is_active = false
	# scene_ended.emit()
	
func is_current_scene():
	return core.current_scene_node == self


# de/activation is needed in cases where the scene is paused and not ended
func _activate():
	pass

func _deactivate():
	pass
