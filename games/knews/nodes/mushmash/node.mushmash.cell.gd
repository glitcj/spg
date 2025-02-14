extends Node2D
class_name MushMashCell

# enum AnimationState {Idle, Excited}
# var animation
# var state
var settings: MushMashCellSettings

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal animation_player_is_ready


# TODO: This messes with the children being added etc
"""
func _init(settings_: MushMashCellSettings = MushMashCellSettings.new()):
	settings = settings_
	# super()
"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	# animation_player = $AnimationPlayer # get_node("AnimationPlayer")
	animation_player_is_ready.emit
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# animation_player.play("RESET")
	pass

# TODO: Add animated sprite texture resize option
func absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / $Body/Sprite2D.texture.get_width()
	var scale_y = float(desired_height) / $Body/Sprite2D.texture.get_height()
	if keep_ratio:
		pass
	# Absolute scale is applied to GFX, not Sprite2D to enable relative 
	# animation in the Godot editor.
	$Body.scale = Vector2(scale_x, scale_y)
	


"""
func framed_absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / sprite_frames.get_frame_texture(animation, frame).get_width()
	var scale_y = float(desired_height) / sprite_frames.get_frame_texture(animation, frame).get_height()
	
	if keep_ratio:
		pass
	
	# Absolute scale is applied to GFX, not Sprite2D to enable relative 
	# animation in the Godot editor.
	# $GFX.scale = Vector2(scale_x, scale_y)
	scale = Vector2(scale_x, scale_y)
	
"""
