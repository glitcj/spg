extends _Core_Scene
class_name _Swiper

@export_category("Words")
@export var words : Array[String]

signal option_selected(selection)


# var correct_answer_index
# var incorrect_answer_index


var verses := []
var total_verses_on_page = 5
# const var verses_on_page = 5

var selection : String

var scroll_counter = 100


var koran_loader : _Core_Data_Lambdas
var start_ayah_index

var visible_labels : Array = []
var visible_indices : Array = []


func _on_scene_end():
	super()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	
	for label : Label in find_children("*", "Label"):
		label.visible = false
	
	koran_loader = _Core_Data_Lambdas.new()
	koran_loader.load_quran_csv("res://assets/kooran_de_go/quran.csv")
	



func _initiate_visible_labels(start_ayah_index):
	var verse
	var scroll_position
	
	for i in range(total_verses_on_page):
		visible_indices.append(start_ayah_index + i)
		visible_labels.append(koran_loader.quran_db[start_ayah_index + i]["ayah_ar"])
		
		
		
		# verse = Label.new().label_settings = LabelSettings.new()
		
		verse = find_child("_verse_%s" % i) as Node2D
		verses.append(verse)
		scroll_position = find_child("_scroll_position_%s" % i) as CenterContainer
		
		# print(visible_labels)
		verse.find_child("Label").text = visible_labels[i]
		verse.find_child("Label").visible = true
		# await _Core_Tweener._slide_in(find_child("_verse_%s" % i), .5)
		
		var tweener = verse.create_tween()
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
		await tweener.finished
		print(visible_indices, visible_labels, verse.global_position)


func _on_scene_start():
	super()
	await get_tree().process_frame
	
	_reset_scroll_counter()
	start_ayah_index = 1 + (randi() % koran_loader.quran_db.size())
	_initiate_visible_labels(start_ayah_index)
	
	
func _scroll_down():
	var verse : Node2D
	var scroll_position : CenterContainer
	for i in range(total_verses_on_page):
		verse = verses[i] as Node2D
		scroll_position = find_child("_scroll_position_%s" % ((i + 1) % total_verses_on_page))
		var tweener = verse.create_tween()
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
	verses.insert(0, verses.pop_back())
	
func _scroll_up():
	var verse : Node2D
	var scroll_position : CenterContainer
	for i in range(total_verses_on_page):
		verse = verses[i] as Node2D
		scroll_position = find_child("_scroll_position_%s" % (  range(total_verses_on_page)[(i - 1) % total_verses_on_page]  ))
		var tweener = verse.create_tween()
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
	verses.append(verses.pop_front())

func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			
			if scroll_counter > 0:
				scroll_counter = scroll_counter - 1
				await _scroll_down()
			else:
				option_selected.emit("_word_0")

			
		KEY_LEFT:
			if scroll_counter > 0:
				scroll_counter = scroll_counter - 1
				await _scroll_up()
			else:
				option_selected.emit("_word_1")
		_:
			pass


func _show_decision():
	if selection == "_verse_%s" % 0:
		%_marubatsu.frame = 0
	else:
		%_marubatsu.frame = 1
	
	await _Core_Tweener._slide_in(%_marubatsu)
	await get_tree().create_timer(.25).timeout
	await _Core_Tweener._slide_out(%_marubatsu)


func _reset_scroll_counter():
	scroll_counter = 100
