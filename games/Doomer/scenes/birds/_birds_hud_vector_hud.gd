extends MarginContainer
class_name _Core_Log_Vector

@export var to_log : Callable = func(): return:
	set(value):
		to_log = value
var vector

@export var max_vector_length = 1. # expected maximum length
var hud_vector_length_multiplier = 300.
var hud_vector_length

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
	
func update():
	if to_log.call() == null:
		return
	
	vector = to_log.call() as Vector2
	%"Label Name".text = to_log.get_method()
	%"Label Value".text = "(%.2f, %.2f), length: %.2f" % [vector.x, vector.y, vector.length()]
	
	hud_vector_length = (1. / max_vector_length) * hud_vector_length_multiplier
	var changed_points = %"Line2D Vector".points
	changed_points[1] = vector * hud_vector_length
	%"Line2D Vector".points = changed_points
