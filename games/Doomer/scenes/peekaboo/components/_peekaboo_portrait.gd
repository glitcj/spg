@tool
extends Node2D
class_name _Peekaboo_Portrait

var sprite : String:
	set(v):
		sprite = v
		if has_node("%AnimatedSprite2D"):
			%AnimatedSprite2D.animation = sprite


@export var _frame := 0:
	set(v):
		$AnimatedSprite2D.frame = v
		_frame = v

@export_enum("ghost", "evaporate", "highlight") var matter: String = "highlight":
	set(v):
		if v == "highlight":
			var _material = ShaderMaterial.new() as ShaderMaterial
			_material.shader = load("res://scenes/peekaboo/shaders/_peekaboo_shader_highlight.gdshader")
			%AnimatedSprite2D.material = _material
		if v == "evaporate":
			var _material = ShaderMaterial.new() as ShaderMaterial
			_material.shader = load("res://scenes/peekaboo/shaders/_peekaboo_shader_evaporate.gdshader")
			%AnimatedSprite2D.material = _material
		if v == "ghost":
			var _material = ShaderMaterial.new() as ShaderMaterial
			_material.shader = load("res://scenes/peekaboo/shaders/_peekaboo_shader_ghost.gdshader")
			%AnimatedSprite2D.material = _material
		matter = v


@onready var animation_player : AnimationPlayer = %AnimationPlayer as AnimationPlayer

# 2. Override to define the property
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	# Fetch names dynamically right now
	var anim_names = _get_available_animation_names()
	
	properties.append({
		"name": "sprite",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(anim_names) 
	})
	
	return properties

# 3. Improved helper function
func _get_available_animation_names() -> Array:
	# Use get_node instead of find_child for performance if you know where it is
	var sprite_node = get_node_or_null("AnimatedSprite2D") # Adjust path if needed
	
	if sprite_node and sprite_node.sprite_frames:
		return Array(sprite_node.sprite_frames.get_animation_names())
	
	return ["None"] # Fallback if node isn't found



func _ready() -> void:
	if matter == "evaporate":
		_tween_material()

func _tween_material():
	var tween = create_tween()
	tween.tween_method(
		func(v): $AnimatedSprite2D.material.set_shader_parameter("evaporate_progress", v),
		0.0, 1.0, 20.0  # duration in seconds
	)
	tween.parallel().tween_method(
		func(v): $Sprite2D.material.set_shader_parameter("evaporate_progress", v),
		0.0, 1.0, 20.0  # duration in seconds
	)

# Animation helpers
func face_down(): %AnimationPlayer.play("move_down")
func face_up(): %AnimationPlayer.play("move_up")
func face_left(): %AnimationPlayer.play("move_left")
func face_right(): %AnimationPlayer.play("move_right")
