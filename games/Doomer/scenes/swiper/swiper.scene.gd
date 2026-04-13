extends _Core_Scene
class_name _Swiper

@export_category("Words")
@export var words : Array[String]

signal option_selected(selection)

func _on_scene_end():
	super()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	
	for label : Label in find_children("*", "Label"):
		label.visible = false
		

func _on_scene_start():
	super()
	await get_tree().process_frame
	await _Core_Tweener._slide_in(find_child("_definition"), .5)
	await _Core_Tweener._slide_in(find_child("_word_1"), .5, Vector2i(-1, 0))
	await _Core_Tweener._slide_in(find_child("_word_2"), .5, Vector2i(1, 0))



func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			await _Core_Tweener._slide_out(find_child("_word_1"), .5, Vector2i(1, 0))
			
			_Core_Tweener._slide_out(find_child("_word_2"), .5, Vector2i(0, 1))
			await _Core_Tweener._slide_out(find_child("_definition"), .5, Vector2i(0, 1))
			option_selected.emit("_word_1")

			
		KEY_LEFT:
			await _Core_Tweener._slide_out(find_child("_word_2"), .5, Vector2i(-1, 0))
			
			_Core_Tweener._slide_out(find_child("_word_1"), .5, Vector2i(0, 1))
			await _Core_Tweener._slide_out(find_child("_definition"), .5, Vector2i(0, 1))
			option_selected.emit("_word_2")
			
		_:
			pass
