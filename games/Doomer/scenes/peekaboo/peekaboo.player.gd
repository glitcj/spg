extends Node2D
class_name _RPGM_Player


@export var peekaboo : _RPGM
var is_active = false:
	set(v):
		if get_RPGM() and not get_RPGM().is_active:
			return
		is_active = v

@onready var mover = find_child("_RPGM_Mover") as _RPGM_Mover
@onready var map = find_parent("_RPGM_Map") as _RPGM_Map

func get_portrait(): return find_child("_RPGM_Portrait") as _RPGM_Portrait
func get_RPGM(): return find_parent("_RPGM") as _RPGM



var direction = Vector2i.ZERO as Vector2i
var next_direction = Vector2i.ZERO:
	set(v):
		next_direction = v
		
var input_just_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not get_RPGM().is_active:
		return
		
	is_active = true	
	for script : _RPGM_Script in get_RPGM().get_map().scripts_currently_on_map():
		if script.is_running() and script.interrupt_player:
			is_active = false
			
	_process_input()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	if next_direction != direction:
		await get_tree().physics_frame # Allow time for future position collision physics
		
		if not mover.tile_has_collision(mover.map_position + Vector2i(next_direction)):
			direction = next_direction
				
	if mover.is_moving:
		return
	
	# var tile_position_delta = direction
	print(mover.map_position, direction, mover.map_position + direction)
	
	if direction == Vector2i.ZERO:
		return
		
	if mover.tile_has_collision(mover.map_position + direction):
		return
		
	if mover.tile_has_collision(mover.map_position + Vector2i(next_direction)):
		direction = Vector2i.ZERO
		next_direction = Vector2i.ZERO	
		return
	
	if direction != Vector2i.ZERO:
		await mover.move(direction)
	
func _valid_direction_is_pressed():
	for d in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if Input.is_action_just_pressed(d):
			return true
	return false
	
func _process_input():# _on_input():
	if Input.is_action_just_pressed("ui_select"):
		_Core_Tweener.new().highlight(self)
		
	if _valid_direction_is_pressed():
		next_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		next_direction = Vector2i(next_direction/next_direction.abs())
		mover.face(next_direction)

	if Input.is_action_just_pressed("ui_accept"):
		reset_movement()

func reset_movement():
	direction = Vector2i.ZERO
	next_direction = Vector2i.ZERO
