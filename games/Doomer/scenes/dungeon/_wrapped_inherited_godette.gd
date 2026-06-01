extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# func get_animation_tree(): return find_child("AnimationTree")
var TIME = 0.0
@onready var animation_tree = find_child("AnimationTree")

func _process(delta: float) -> void:
	TIME += delta

func _physics_process(delta: float) -> void:
	velocity = Vector3(0,0,0) + Vector3(sin(TIME), 0, -sin(TIME)) * 2.
	move_and_slide()
	print(velocity, TIME)
	


# func _movement_loop():
# 	velocity = Vector3(0,0,0)
