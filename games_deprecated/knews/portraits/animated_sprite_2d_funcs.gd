extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / sprite_frames.get_frame_texture(animation, frame).get_width()
	var scale_y = float(desired_height) / sprite_frames.get_frame_texture(animation, frame).get_height()
	
	if keep_ratio:
		pass
	
	# Absolute scale is applied to GFX, not Sprite2D to enable relative 
	# animation in the Godot editor.
	# $GFX.scale = Vector2(scale_x, scale_y)
	scale = Vector2(scale_x, scale_y)
	
