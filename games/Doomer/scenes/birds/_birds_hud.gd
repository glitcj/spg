extends PanelContainer
class_name _Birds_HUD


var max_speed_bar_length = 250
@export var log = "":
	set(v):
		log = to_log_as_text() + v
		%"Label Log".text = log
		
var direction := Vector2(0, 0)
var to_log := []

var vector_log_scene = preload("res://scenes/birds/_birds_hud_vector_hud.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_log(to_log : Callable):
	if to_log.call() is Vector2:
		var _log = vector_log_scene.instantiate()
		_log.to_log = to_log
		%VBoxContainer.add_child(_log)


func add_vector_log(to_log : Callable, max_vector_length = 1.0):
	var _log = vector_log_scene.instantiate() as _Core_Log_Vector
	_log.to_log = to_log
	_log.max_vector_length = max_vector_length
	%VBoxContainer.add_child(_log)

	

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
