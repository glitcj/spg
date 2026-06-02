extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var is_moving = false

# func get_animation_tree(): return find_child("AnimationTree")
var TIME = 0.0
@onready var animation_tree = find_child("AnimationTree")

func _process(delta: float) -> void:
	TIME += delta

func _physics_process(delta: float) -> void:
	if int(TIME) % 10 > 5:
		velocity = Vector3(0,0,0) + Vector3(sin(TIME), 0, -sin(TIME)) * 2.
		is_moving = true
		rotation = velocity.normalized()
	else:
		velocity = Vector3(0, 0, 0)
		is_moving = false
		
	
	move_and_slide()
	print(velocity, TIME)
	


# func _movement_loop():
# 	velocity = Vector3(0,0,0)
