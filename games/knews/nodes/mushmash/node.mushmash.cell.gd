extends Node2D
class_name MushMashCell

var settings: MushMashCellSettings
var sprite_sheets: Dictionary


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(settings != null)
	settings._preload_animation_sprites()
	change_sprite_sheet(settings.cell_sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "(%s,%s) \n %s" % [settings.x, settings.y, settings.uuid.substr(0,8)]

# TODO: Add animated sprite texture resize option
func absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / $Body/Sprite2D.texture.get_width()
	var scale_y = float(desired_height) / $Body/Sprite2D.texture.get_height()
	if keep_ratio:
		pass
	$Body.scale = Vector2(scale_x, scale_y)


func absolute_rescale_framed(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var animated_sprite_2D: AnimatedSprite2D = $Body/AnimatedSprite2D
	var texture: Texture2D = animated_sprite_2D.sprite_frames.get_frame_texture(animated_sprite_2D.animation, animated_sprite_2D.frame)
	var scale_x = float(desired_width) / texture.get_width()
	var scale_y = float(desired_height) / texture.get_height()
	if keep_ratio:
		pass
	animated_sprite_2D.scale = Vector2(scale_x, scale_y)




func change_sprite_sheet(sprite_id: int):
	var new_texture = settings.sprite_sheets[sprite_id]
	var sprite_frames: SpriteFrames = $Body/AnimatedSprite2D.sprite_frames

	
	# Update the texture of all frames without changing frame configuration
	for animation_name in sprite_frames.get_animation_names():
		var frame_count = sprite_frames.get_frame_count(animation_name)
		for i in range(frame_count):
			# Get the old texture for this frame
			var old_texture = sprite_frames.get_frame_texture(animation_name, i)
			# Create a new AtlasTexture using the new sprite sheet but keep the same region
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = new_texture
			atlas_texture.region = old_texture.region
			atlas_texture.region = old_texture.region
			atlas_texture.filter_clip = old_texture.filter_clip
			
			sprite_frames.set_frame(animation_name, i, atlas_texture)
	
	# If you want to restart the animation
	$Body/AnimatedSprite2D.play()
