extends _Core_Viewport
class_name _Desert
# Change to _DesertCamp FPS
# Shoot incoming zombies, and recite poetry after each stage

# Add night sky
# Add night sky shader
# Add 3d fire shader 
# Add stage loop, reward is a poem shining in the sky
# Poem correlates with score
# looking up you can shoot boosters in the sky for power ups

signal finished

func get_hud(): return %_Core_Log as _Core_Log

func _ready() -> void:
	camera = %Camera2D as Camera2D

func _on_viewport_start():	
	super()
	
func _on_viewport_end():
	super()
	(find_child("_Desert_Player") as _Desert_Player).position = Vector3.ZERO
	
func finish():
	finished.emit()
