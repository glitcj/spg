extends Node2D
class_name _Peekaboo_Portrait

enum EnemySprite {cream, red}

# const GHOST_MATERIAL = preload("res://scenes/peekaboo/peekaboo.shader.enemy.gdshader")


@export var sprite : EnemySprite = EnemySprite.cream:
	set(v):
		%AnimatedSprite2D.animation = EnemySprite.keys()[v]
		sprite = v
		
@export var is_ghost = false:
	set(v):
		is_ghost = v
		_update_material()

@onready var animation_player : AnimationPlayer = %AnimationPlayer as AnimationPlayer



func _update_material():
	# TODO: Understand more about light masks, and shaders, light bitmasks arent simple filters
	if %AnimatedSprite2D:
		if not is_ghost:
			%AnimatedSprite2D.material = null
			%AnimatedSprite2D.light_mask = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_material()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func face_down():
	create_tween().tween_property(%AnimatedSprite2D, "frame", 0, 0.0001)
	
func face_right():
	create_tween().tween_property(%AnimatedSprite2D, "frame", 6, 0.0001)
	
func face_left():
	create_tween().tween_property(%AnimatedSprite2D, "frame", 3, 0.0001)
	
func face_up():
	create_tween().tween_property(%AnimatedSprite2D, "frame", 11, 0.0001)
	
