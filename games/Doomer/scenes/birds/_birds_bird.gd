extends Node2D
class_name _Birds_Bird

func _get_viewport(): return find_parent("_Birds") as _Core_Viewport

var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%_RPGM_Portrait.face_down()
	_loop_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _get_viewport().is_active: return
	%_passive_movement_anchor.position +=  Vector2(-1, 0) * speed


func move(destination: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(%_tween_movement_anchor, "position", destination, .1)
	await tween.finished
	
	

func _loop_timer():
	await get_tree().create_timer(1.).timeout
	
	if _get_viewport().is_active:
		var possible_directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
		var direction = possible_directions[randi() % possible_directions.size()]
		move(%_tween_movement_anchor.position + direction * 50)
			
	_loop_timer()
