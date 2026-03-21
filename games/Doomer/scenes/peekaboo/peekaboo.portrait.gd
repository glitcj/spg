@tool
extends Node2D
class_name _Peekaboo_Portrait

enum EnemySprite {cream, red, player, blue}

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

func face_down(): %AnimationPlayer.play("move_down")
func face_up(): %AnimationPlayer.play("move_up")
func face_left(): %AnimationPlayer.play("move_left")
func face_right(): %AnimationPlayer.play("move_right")
