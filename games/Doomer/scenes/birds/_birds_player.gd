extends CharacterBody2D
class_name _Birds_Player

func _get_viewport(): return find_parent("_Birds") as _Birds
func get_hud(): return _get_viewport().get_hud() as _Birds_HUD

var birds_direction = Vector2(0,0)
var player_input_direction = Vector2(0,0)
var accumulated_direction = Vector2(0,0)
var player_input_movement = Vector2(0,0)
var wind_movement = Vector2(0.2, 0)

var max_speed = 300

var speed = 2

func _ready() -> void:
	%_RPGM_Portrait.face_down()
	
func _process(delta : float):
	pass
	
func _process_echoed_input():
	player_input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	accumulated_direction += player_input_direction * .25
	accumulated_direction.x = sign(accumulated_direction.x) * min(1., abs(accumulated_direction.x))
	accumulated_direction.y = sign(accumulated_direction.y) * min(1., abs(accumulated_direction.y)) 
	
func _input(event: InputEvent) -> void:
	if not _get_viewport().is_active: return
	if not (event is InputEventKey): return
	_process_echoed_input()
	
	if not (event.pressed and not event.echo): return
	
func _physics_process(delta: float) -> void:
	if not _get_viewport().is_active: return
	player_input_movement = accumulated_direction
	
	get_hud().speed = speed
	
	if delta - floor(delta)  < 0.1:
		# _process_physics is quantized every 0.1, which makes direction change detection quirky
		pass
	
	# if the direction flips..
	if (velocity.x  * (player_input_movement + wind_movement).x) <= 0:
		(%_RPGM_Portrait.find_child("Sprite2D") as Sprite2D).flip_h = player_input_direction.x < 0
		
		
	var input_movement = player_input_movement
	var input_movement_speed = player_input_movement.length()
	var input_plus_passive = player_input_movement + wind_movement
	velocity = input_plus_passive * max_speed
	var input_plus_passive_speed = input_plus_passive.length()
	var normalised_velocity = velocity / velocity.length()
	var velocity_speed = velocity.length()

	get_hud().log = "
	input_movement = %.2f, %.2f, 
	input_movement_speed = %.2f, 
	player_input_direction = %.2f, %.2f, 
	input_plus_passive = %.2f, %.2f, 
	input_plus_passive_speed = %.2f,
	velocity = %.2f , %.2f,
	velocity_speed = %.2f,
	normalised_velocity = %.2f , %.2f," % [input_movement.x, input_movement.y, input_movement_speed, player_input_direction.x, player_input_direction.y, input_plus_passive.x, input_plus_passive.y,  input_plus_passive_speed, velocity.x, velocity.y, velocity_speed, normalised_velocity.x, normalised_velocity.y,]
	move_and_slide()
