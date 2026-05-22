extends PanelContainer
class_name _Birds_HUD


var max_speed_bar_length = 250
@export var log = "":
	set(v):
		log = to_log_as_text() + v
		%"Label Log".text = log

@export var speed := .5:
	set(v):
		# %"Line2D Speed".set_point_position(1, Vector2(0, v * max_speed_bar_length))
		
		var changed_points = %"Line2D Speed".points
		changed_points[1] = Vector2(0, v * max_speed_bar_length)
		%"Line2D Speed".points = changed_points
		
		speed = v 
		
var direction := Vector2(0, 0)
var to_log := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func to_log_as_text():
	var tmp = ""
	var item
	for c : Callable in to_log:
		item = c.call()
		if item is Vector2:
			item = item as Vector2
			tmp = tmp + "%s %.2f %.2f
			" % [c.get_method(), item.x, item.y] 
	return tmp
