extends _Core_Viewport
class_name _Birds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	%_portrait.animation_player.play("move_down")


func _on_viewport_start():
	super()
