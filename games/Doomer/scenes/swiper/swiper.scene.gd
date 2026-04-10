extends _Core_Scene
class_name _Swiper

@export_category("Uses")
@export var words : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D

func _on_scene_start():
	super()
