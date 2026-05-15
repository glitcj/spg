extends _Core_Viewport
class_name _Birds




var birds_direction = Vector2(0,0)
var lead_bird_direction = Vector2(0,0)

signal finished
var grid_size = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	%_portrait.animation_player.play("move_down")
	
	for portrait : _RPGM_Portrait in find_children("*","_RPGM_Portrait"):
		portrait.scale = Vector2(5, 5)
		portrait.face_down()
		
	_loop_timer()

func _loop_timer():
	await get_tree().create_timer(1.).timeout
	
	if is_active:
		var possible_directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		birds_direction = possible_directions[randi() % possible_directions.size()]
		for bird : _RPGM_Portrait in find_children("_portrait","_RPGM_Portrait"):
			move_bird(bird, bird.global_position + birds_direction * 50)
			
	_loop_timer()
func _on_viewport_start():
	super()
	
func _on_viewport_end():
	super()
	
func move_bird(bird : _RPGM_Portrait, _position: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(bird, "global_position", _position, .1)
	await tween.finished
	
	
func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			lead_bird_direction = Vector2(1, 0)
			
		KEY_LEFT:
			lead_bird_direction = Vector2(-1, 0)
			
		KEY_UP:
			lead_bird_direction = Vector2(0, -1)
			
		KEY_DOWN:
			lead_bird_direction = Vector2(0, 1)
			
		KEY_ENTER:
			lead_bird_direction = Vector2(0, 0)
			
		KEY_ESCAPE:
			finished.emit()
			
		_:
			pass
			
func _physics_process(delta: float) -> void:
	%_lead_bird.velocity = lead_bird_direction * 100
	%_lead_bird.move_and_slide()
