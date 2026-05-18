extends Node2D
class_name _Birds_Level



func _get_viewport(): return find_parent("_Birds") as _Birds
var birds_direction = Vector2(0,0)
# var lead_bird_direction = Vector2(0,0)
# var player_input_movement
# var passive_movement = Vector2(300, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# camera = %Camera2D as Camera2D
	# %_portrait.animation_player.play("move_down")
	pass
	
func _input(event: InputEvent) -> void:
	if not _get_viewport().is_active: return
	if not (event is InputEventKey): return
	if not (event.pressed and not event.echo): return
	
	# Replace "ui_..." with your custom action names from the Input Map
	# var _direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		
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
			# lead_bird_direction = Vector2(0, 0)
			pass
			
		KEY_ESCAPE:
			_get_viewport().finished.emit()
			
		_:
			pass
			
func _physics_process(delta: float) -> void:
	if not _get_viewport().is_active: return
	# player_input_movement = lead_bird_direction * 100
	# %_lead_bird.velocity = player_input_movement + passive_movement
	# %_lead_bird.move_and_slide()
