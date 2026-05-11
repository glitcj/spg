extends _Core_Viewport
class_name _Birds

signal finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	%_portrait.animation_player.play("move_down")
	
func _on_viewport_start():
	super()
	
func _on_viewport_end():
	super()
	
func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			pass
			
		KEY_LEFT:
			pass

		KEY_ESCAPE:
			finished.emit()
			
		_:
			pass
