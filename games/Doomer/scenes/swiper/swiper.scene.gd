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
	
	
	var correct_answer_index = randi() % 2
	var incorrect_answer_index
	incorrect_answer_index = int(not correct_answer_index)



	# var koran = _Core_Data_Lambdas.new().load_csv("res://assets/kooran_de_go/quran.csv") as Array
	var koran_loader = _Core_Data_Lambdas.new()
	koran_loader.load_quran_csv("res://assets/kooran_de_go/quran.csv")
	var start_ayah_index = 1 + (randi() % koran_loader.quran_db.size())
	
	var decoy_ayah_index = 1 + (randi() % koran_loader.quran_db.size())

	print(correct_answer_index, incorrect_answer_index, "_word_%s" % correct_answer_index, "_word_%s" % incorrect_answer_index)
	(find_child("_definition") as Label).text = koran_loader.quran_db[start_ayah_index]["ayah_ar"]
	(find_child("_word_%s" % correct_answer_index) as Label).text = koran_loader.quran_db[start_ayah_index + 1]["ayah_ar"]
	(find_child("_word_%s" % incorrect_answer_index) as Label).text = koran_loader.quran_db[decoy_ayah_index]["ayah_ar"]
	

	await _Core_Tweener._slide_in(find_child("_definition"), .5)
	await _Core_Tweener._slide_in(find_child("_word_0"), .5, Vector2i(-1, 0))
	await _Core_Tweener._slide_in(find_child("_word_1"), .5, Vector2i(1, 0))

	
	"""
	# print(koran.slice(0, 10))
	print(koran_loader.quran_db.keys().slice(0,10))
	# print(koran_loader.quran_db.values().slice(0,10))
	for i in range(10):
		# print(koran_loader.quran_db["%s" % i]["ayah_ar"])
		print(koran_loader.quran_db[i +1]["ayah_ar"])
	"""
	
	



func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			await _Core_Tweener._slide_out(find_child("_word_0"), .5, Vector2i(1, 0))
			
			_Core_Tweener._slide_out(find_child("_word_1"), .5, Vector2i(0, 1))
			await _Core_Tweener._slide_out(find_child("_definition"), .5, Vector2i(0, 1))
			option_selected.emit("_word_0")

			
		KEY_LEFT:
			await _Core_Tweener._slide_out(find_child("_word_1"), .5, Vector2i(-1, 0))
			
			_Core_Tweener._slide_out(find_child("_word_0"), .5, Vector2i(0, 1))
			await _Core_Tweener._slide_out(find_child("_definition"), .5, Vector2i(0, 1))
			option_selected.emit("_word_1")
			
		_:
			pass
