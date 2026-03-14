extends Node2D
class_name _PeekaBoo_Player


@export var peekaboo : _PeekaBoo
var is_active = true


@onready var tweener = %_Peekaboo_Tweener as _Peekaboo_Tweener

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
		print(script.is_running(), script.interrupt_player)
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

	_update_movement()
	
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
		input_just_pressed = true


	if Input.is_action_just_pressed("ui_accept"):
		direction = Vector2.ZERO
		next_direction = Vector2.ZERO


func _update_movement():
	if direction == Vector2.ZERO:
		return
	peekaboo.map.player.move_and_collide(direction * peekaboo.player_speed)
	peekaboo.lambdas.update_idle_animation()
