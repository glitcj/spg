extends Node2D
class_name _Peekaboo_Player


@export var peekaboo : _Peekaboo
var is_active = true


@onready var tweener = %_Peekaboo_Tweener as _Peekaboo_Tweener
@onready var mover = find_child("_Peekaboo_Mover") as _Peekaboo_Mover

@onready var map = find_parent("_Peekaboo_Map")


func get_portrait(): return find_child("_Peekaboo_Portrait") as _Peekaboo_Portrait

var direction = Vector2.ZERO as Vector2
var next_direction = Vector2.ZERO:
	set(v):
		next_direction = v
		%"future position".position = next_direction * 100
		
var input_just_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_active = true	
	for script : _Peekaboo_Script in peekaboo.scripts_currently_on_map():
		if script.is_running() and script.interrupt_player:
			is_active = false
	_on_input()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	if next_direction != direction:
		if input_just_pressed:
			input_just_pressed = false
		else:
			if %"future position".get_overlapping_bodies().size() == 0:
				direction = next_direction
				
	if mover.is_moving:
		return
	
	var tile_position_delta = direction / direction.abs() as Vector2i
	
	
	if mover.tile_has_collision(mover.map_position + tile_position_delta):
		return
	
	for body in %"future position".get_overlapping_bodies():
		if body is RigidBody2D and body is not CharacterBody2D:
			body = body as RigidBody2D
			direction = Vector2.ZERO
			next_direction = Vector2.ZERO
			return
	
	if tile_position_delta != Vector2i.ZERO:
		await mover.move(tile_position_delta)
	
func _valid_direction_is_pressed():
	
	for d in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if Input.is_action_just_pressed(d):
			return true
	return false
	
func _on_input():
	if Input.is_action_just_pressed("ui_select"):
		tweener.highlight()
		
		
	if _valid_direction_is_pressed():
		next_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		await mover.face(next_direction/next_direction.abs())
		
		input_just_pressed = true


	if Input.is_action_just_pressed("ui_accept"):
		reset_movement()
		# direction = Vector2.ZERO
		# next_direction = Vector2.ZERO


func reset_movement():
	# get_portrait().face_down()
	direction = Vector2.ZERO
	next_direction = Vector2.ZERO
	
func _update_movement():
	if direction == Vector2.ZERO:
		return
	peekaboo.map.player.move_and_collide(direction * peekaboo.player_speed)
	peekaboo.lambdas.update_idle_animation()
