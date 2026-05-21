extends PanelContainer
class_name _Birds_HUD


var max_speed_bar_length = 250
@export var log = "":
	set(v):
		%"Label Log".text = log
		log = v

@export var speed := .5:
	set(v):
		# %"Line2D Speed".set_point_position(1, Vector2(0, v * max_speed_bar_length))
		
		var changed_points = %"Line2D Speed".points
		changed_points[1] = Vector2(0, v * max_speed_bar_length)
		%"Line2D Speed".points = changed_points
		
		speed = v 
		
var direction := Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
