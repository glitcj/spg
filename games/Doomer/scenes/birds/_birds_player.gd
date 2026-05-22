extends CharacterBody2D
class_name _Birds_Player

func _get_viewport(): return find_parent("_Birds") as _Birds
func get_hud(): return _get_viewport().get_hud() as _Birds_HUD

var birds_direction = Vector2(0,0)
var player_input_direction = Vector2(0,0)
var accumulated_direction = Vector2(0,0)
var player_input_movement = Vector2(0,0)
var wind_movement = Vector2(0.2, 0)
var input_plus_passive = Vector2(0,0)

var max_speed = 300

var speed = 2

func _ready() -> void:
	%_RPGM_Portrait.face_down()
	
	# Logged
	get_hud().to_log.append(get_player_input_movement)
	get_hud().to_log.append(_get_velocity)
	get_hud().to_log.append(get_input_plus_passive)
	get_hud().to_log.append(get_accumulated_direction)
	get_hud().to_log.append(get_player_input_direction)
	
	get_hud().add_log(_get_velocity)
	
func _process(delta : float):
	pass


func get_player_input_movement(): return player_input_movement
func _get_velocity(): return velocity
func get_input_plus_passive(): return input_plus_passive
func get_accumulated_direction(): return accumulated_direction
func get_player_input_direction(): return player_input_direction

func _process_muted_input():
	if Input.is_action_pressed("ui_accept"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "accumulated_direction", Vector2(0,0), 0.5)
	player_input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	accumulated_direction += player_input_direction * .1
	accumulated_direction.x = sign(accumulated_direction.x) * min(1., abs(accumulated_direction.x))
	accumulated_direction.y = sign(accumulated_direction.y) * min(1., abs(accumulated_direction.y)) 
	
	
func _process_echoed_input():
	player_input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	accumulated_direction += player_input_direction * .25
	accumulated_direction.x = sign(accumulated_direction.x) * min(1., abs(accumulated_direction.x))
	accumulated_direction.y = sign(accumulated_direction.y) * min(1., abs(accumulated_direction.y)) 
	
func _input(event: InputEvent) -> void:
	if not _get_viewport().is_active: return
	if not (event is InputEventKey): return
	# _process_echoed_input()
	
	if not (event.pressed and not event.echo): return
	_process_muted_input()

	
func _physics_process(delta: float) -> void:
	if not _get_viewport().is_active: return
	player_input_movement = accumulated_direction
	
	if delta - floor(delta)  < 0.1:
		# _process_physics is quantized every 0.1, which makes direction change detection quirky
		pass
	
	# if the direction flips..
	if (velocity.x  * (player_input_movement + wind_movement).x) <= 0:
		(%_RPGM_Portrait.find_child("Sprite2D") as Sprite2D).flip_h = player_input_direction.x < 0
		
	input_plus_passive = accumulated_direction + wind_movement
	velocity = input_plus_passive * max_speed
	
	get_hud().log = ""
	move_and_slide()
