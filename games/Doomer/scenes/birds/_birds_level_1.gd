extends Node2D
class_name _Birds_Level



func _get_viewport(): return find_parent("_Birds") as _Birds


var birds_direction = Vector2(0,0)
var lead_bird_direction = Vector2(0,0)


var grid_size = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# camera = %Camera2D as Camera2D
	%_portrait.animation_player.play("move_down")
	
	for portrait : _RPGM_Portrait in find_children("*","_RPGM_Portrait"):
		portrait.scale = Vector2(5, 5)
		portrait.face_down()
		
	_loop_timer()

func _loop_timer():
	await get_tree().create_timer(1.).timeout
	
	if _get_viewport().is_active:
		var possible_directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		birds_direction = possible_directions[randi() % possible_directions.size()]
		for bird : _RPGM_Portrait in find_children("_portrait","_RPGM_Portrait"):
			move_bird(bird, bird.global_position + birds_direction * 50)
			
	_loop_timer()

	
func move_bird(bird : _RPGM_Portrait, _position: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(bird, "global_position", _position, .1)
	await tween.finished
	
	
func _input(event: InputEvent) -> void:
	if not _get_viewport().is_active: return
	if not (event is InputEventKey): return
	if not (event.pressed and not event.echo): return
	
	
	
	# Replace "ui_..." with your custom action names from the Input Map
	var _direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if _direction:
		lead_bird_direction = _direction
	else:
		# velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		pass
		
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			# lead_bird_direction = Vector2(1, 0)
			pass
			
		KEY_LEFT:
			# lead_bird_direction = Vector2(-1, 0)
			pass
			
		KEY_UP:
			# lead_bird_direction = Vector2(0, -1)
			pass
			
		KEY_DOWN:
			# lead_bird_direction = Vector2(0, 1)
			pass
			
		KEY_ENTER:
			lead_bird_direction = Vector2(0, 0)
			
		KEY_ESCAPE:
			_get_viewport().finished.emit()
			
		_:
			pass
			
func _physics_process(delta: float) -> void:
	%_lead_bird.velocity = lead_bird_direction * 100
	%_lead_bird.move_and_slide()
