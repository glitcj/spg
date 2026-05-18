extends CharacterBody2D
class_name _Birds_Player

func _get_viewport(): return find_parent("_Birds") as _Birds

var birds_direction = Vector2(0,0)
var player_input_direction = Vector2(0,0)
var player_input_accumulated_direction = Vector2(0,0)
var player_input_movement = Vector2(0,0)
var passive_movement = Vector2(300, 0)

func _ready() -> void:
	%_RPGM_Portrait.face_down()
	
func _process(delta : float):
	pass
	
func _process_echoed_input():
	player_input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	player_input_accumulated_direction += player_input_direction * 1
	
func _input(event: InputEvent) -> void:
	if not _get_viewport().is_active: return
	if not (event is InputEventKey): return
	_process_echoed_input()
	
	if not (event.pressed and not event.echo): return
	
func _physics_process(delta: float) -> void:
	if not _get_viewport().is_active: return
	player_input_movement = player_input_accumulated_direction * 100
	
	if delta - floor(delta)  < 0.1:
		# _process_physics is quantized every 0.1, which makes direction change detection quirky
		pass
	
	# if the direction flips..
	if (velocity.x  * (player_input_movement + passive_movement).x) <= 0:
		(%_RPGM_Portrait.find_child("Sprite2D") as Sprite2D).flip_h = player_input_direction.x < 0

	velocity = player_input_movement + passive_movement
	move_and_slide()
