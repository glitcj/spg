@tool
extends Node2D
class_name _Peekaboo_Portrait


# note: onready variables are ignored by the editor
@onready var animation_player = %AnimationPlayer as AnimationPlayer

@export_category("Portrait")
var _material : ShaderMaterial
@export_enum("ghost", "evaporate", "highlight", "fog", "shine", "function",
			 "random", "wiggle", "sphere", "outline", "chessboard"
			) var type: String = "random":
	set(v):
		type = v
		_update_material()
		
var sprite : String:
	set(v):
		sprite = v
		if has_node("AnimatedSprite2D"):
			%AnimatedSprite2D.animation = sprite
			_update_atlas()
			# queue_redraw()

@export var _frame := 0:
	set(v):
		_frame = v
		if has_node("AnimatedSprite2D"):
			%AnimatedSprite2D.frame = v

var atlas : AtlasTexture

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var anim_names = _get_available_animation_names()
	properties.append({
		"name": "sprite",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(anim_names)
	})
	return properties

func _get_available_animation_names() -> Array:
	var sprite_node = get_node_or_null("AnimatedSprite2D")
	if sprite_node and sprite_node.sprite_frames:
		return Array(sprite_node.sprite_frames.get_animation_names())
	return ["None"]
	
func _update_material():
		_material = ShaderMaterial.new() as ShaderMaterial
		if type == "highlight":
			_material.shader = load("res://scenes/peekaboo/shaders/_highlight.gdshader")
		if type == "evaporate":
			_material.shader = load("res://scenes/peekaboo/shaders/_evaporate.gdshader")
		if type == "ghost":
			_material.shader = load("res://scenes/peekaboo/shaders/_ghost.gdshader")
		if type == "random":
			_material.shader = load("_random.gdshader")
		if type == "wiggle":
			_material.shader = load("res://scenes/peekaboo/shaders/_wiggle.gdshader")
		if type == "sphere":
			_material.shader = load("res://scenes/peekaboo/shaders/_sphere_and_correct_rgb_belnding.gdshader")
		if type == "outline":
			_material.shader = load("res://scenes/peekaboo/shaders/_outline.gdshader")
		if type == "fog":
			_material.shader = load("res://scenes/peekaboo/shaders/_fog.gdshader")
		if type == "chessboard":
			_material.shader = load("res://scenes/peekaboo/shaders/_chessboard.gdshader")
		if type == "shine":
			_material.shader = load("res://scenes/peekaboo/shaders/_shine.gdshader")
		if type == "function":
			_material.shader = load("res://scenes/peekaboo/shaders/_function.gdshader")
			
		if not is_node_ready(): return
		material = _material
		
func _ready() -> void:
	if get_tree().current_scene != self: %Camera2D.enabled = false
	
	atlas = AtlasTexture.new()
	%Sprite2D.texture = atlas

	# connect signal — fires automatically whenever animated.frame changes
	%AnimatedSprite2D.frame_changed.connect(_update_atlas)

	# sync atlas to whatever frame is current on load
	_update_atlas()
	_update_material()
	
func _update_atlas():
	var frame = %AnimatedSprite2D.frame
	var tex = %AnimatedSprite2D.sprite_frames.get_frame_texture(%AnimatedSprite2D.animation, frame)
	
	var source_image : Image
	var region : Rect2
	
	if tex is AtlasTexture:
		source_image = tex.atlas.get_image()
		region = tex.region
	else:
		source_image = tex.get_image()
		region = Rect2(Vector2.ZERO, tex.get_size())
	
	# extract just this frame's pixels into a brand new standalone texture
	# UV will now genuinely be 0→1 with no atlas behind it
	var cropped = source_image.get_region(Rect2i(region))
	%Sprite2D.texture = ImageTexture.create_from_image(cropped)
	
func _tween_material_progress(duration := 10.0):
	var tween = create_tween()
	tween.tween_method(
		func(v): $AnimatedSprite2D.material.set_shader_parameter("progress", v),
		0.0, 1.0, duration
	)
	
func face_down(): %AnimationPlayer.play("move_down")
func face_up(): %AnimationPlayer.play("move_up")
func face_left(): %AnimationPlayer.play("move_left")
func face_right(): %AnimationPlayer.play("move_right")
