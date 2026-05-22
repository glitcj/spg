extends _Core_Viewport
class_name _Birds

signal finished

func get_hud(): return %_Birds_HUD as _Birds_HUD

func _ready() -> void:
	camera = %Camera2D as Camera2D


func _on_viewport_start():
	super()
	
func _on_viewport_end():
	super()
	
