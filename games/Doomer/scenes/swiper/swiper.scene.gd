extends _Core_Scene
class_name _Swiper

@export_category("Uses")
@export var words : Array[String]


func _on_scene_end():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D

func _on_scene_start():
	super()
	await get_tree().process_frame
	await _Peekaboo_Tweener._slide_in(find_child("_definition"), .25, false)
	await _Peekaboo_Tweener._slide_in(find_child("_word_1"), .25, false)
	await _Peekaboo_Tweener._slide_in(find_child("_word_2"), .25, false)
