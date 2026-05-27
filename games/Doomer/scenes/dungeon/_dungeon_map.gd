extends Node3D
class_name Dungeon_Map

var TIME = 0.
var camera_rotation_sensitivity = 0.02
var camera_movement_sensitivity = 0.2
var wasd_as_rotation = false

func _get_viewport(): return find_parent("_Desert") as _Desert

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event : InputEvent): if not (event.pressed and not event.echo): pass # stutters and is not synced with physics frames
func _process_physics_input(): pass 
func _process_muted_input(): pass # used with is_action_just_pressed


var vector_pointing_to_camera_right : Vector3
var vector_pointing_to_camera_forward : Vector3
func _get_camera_basis():
	var cam_basis = %Camera3D.global_transform.basis as Basis
	vector_pointing_to_camera_right   =  cam_basis.x # strafe
	vector_pointing_to_camera_forward = -cam_basis.z # forward is -Z in Godot
	# Grounded FPS — flatten forward so you don't fly when looking up/down
	vector_pointing_to_camera_forward.y = 0.
	vector_pointing_to_camera_forward = vector_pointing_to_camera_forward.normalized()
	
func _process_echoed_input():
	var direction_input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var wasd_input = Input.get_vector("ui_a", "ui_d", "ui_s", "ui_w")
	_get_camera_basis()
	
	if wasd_as_rotation:
		%Camera3D.rotation += Vector3(wasd_input.y, -wasd_input.x, 0.) * camera_rotation_sensitivity
		%Camera3D.position += (vector_pointing_to_camera_right * direction_input.x + vector_pointing_to_camera_forward * direction_input.y) * camera_movement_sensitivity
	else:
		%Camera3D.rotation += Vector3(direction_input.y, -direction_input.x, 0.) * camera_rotation_sensitivity
		%Camera3D.position += (vector_pointing_to_camera_right * wasd_input.x + vector_pointing_to_camera_forward * wasd_input.y) * camera_movement_sensitivity

func _process_input() -> void:
	if not _get_viewport().is_active: return
	_process_echoed_input()
	_process_muted_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_time(delta)
	# %Camera3D.position.x += sin(TIME/10) * .01
	%_model_1.position.x += cos(TIME/10) * .1
	%_model_1.position.z += cos(TIME/10) * .1
	
	_process_input()

func _physics_process(delta: float) -> void:
	_process_physics_input()

func _update_time(delta: float):
	TIME += delta * 10
