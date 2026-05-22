extends MarginContainer
class_name _Core_Log_Vector

@export var to_log : Callable = func(): return

var vector
var hud_vector_length = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
	
func update():	
	if to_log == null:
		return
	print(to_log, to_log == null)
	if to_log.call() == null:
		return
		
	vector = to_log.call() as Vector2
	%"Label Name".text = to_log.get_method()
	%"Label Value".text = "(%.2f, %.2f), length: %.2f" % [vector.x, vector.y, vector.length()]
	
	var changed_points = %"Line2D Speed".points
	changed_points[1] = vector * hud_vector_length # Vector2(0, vector * hud_vector_length)
	%"Line2D Speed".points = changed_points
