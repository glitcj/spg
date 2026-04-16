extends _Core_Scene
class_name _Swiper

@export_category("Words")
@export var words : Array[String]

signal option_selected(selection)


var interrupt_scroll = true

var verses := []
var total_verses_on_page = 5


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
	koran_loader = _Core_Data_Lambdas.new()
	koran_loader.load_quran_csv("res://assets/kooran_de_go/quran.csv")
	



func _initiate_visible_labels(start_ayah_index):
	var verse : Node2D
	var scroll_position
	
	for i in range(total_verses_on_page):
		verse = find_child("_verse_%s" % i) as Node2D
		verse.index = start_ayah_index + i
		verse.text = koran_loader.quran_db[start_ayah_index + i]["ayah_ar"]
		verses.append(verse)
		scroll_position = find_child("_scroll_position_%s" % i) as Node2D
		
		var tweener = verse.create_tween()
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
		tweener.parallel().tween_property(verse, "modulate", scroll_position.applied_modulate, .25)
		tweener.parallel().tween_property(verse, "scale", scroll_position.applied_scale, .25)
		
		await tweener.finished
		print(visible_indices, visible_labels, verse.global_position)
		
func _on_scene_start():
	super()
	await get_tree().process_frame
	
	
	_reset_scroll_counter()
	start_ayah_index = 1 # + (randi() % koran_loader.quran_db.size())
	await _initiate_visible_labels(start_ayah_index)
	interrupt_scroll = false
	
func _scroll_down():
	
	if verses[0].index == 1:
		return
		
	var verse : Node2D
	var scroll_position : Node2D
	for i in range(total_verses_on_page):
		verse = verses[i] as Node2D
		scroll_position = find_child("_scroll_position_%s" % ((i + 1) % total_verses_on_page))
		

			
		var tweener = verse.create_tween()
		
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
		tweener.parallel().tween_property(verse, "modulate", scroll_position.applied_modulate, .25)
		tweener.parallel().tween_property(verse, "scale", scroll_position.applied_scale, .25)
		
		if i == total_verses_on_page - 1:
			verse.index = verses[0].index - 1
			verse.text = koran_loader.quran_db[verse.index]["ayah_ar"]
			
		
	verses.insert(0, verses.pop_back())
	
func _scroll_up():
	if verses[-1].index == koran_loader.quran_db.size() - 1:
		return
		
	var verse : Node2D
	var scroll_position : Node2D
	for i in range(total_verses_on_page):
		verse = verses[i] as Node2D
		scroll_position = find_child("_scroll_position_%s" % (range(total_verses_on_page)[(i - 1) % total_verses_on_page]))
		

		var tweener = verse.create_tween()
		tweener.tween_property(verse, "global_position", scroll_position.global_position, .25)
		tweener.parallel().tween_property(verse, "modulate", scroll_position.applied_modulate, .25)
		tweener.parallel().tween_property(verse, "scale", scroll_position.applied_scale, .25)
		
		if i == 0:
			verse.index = verses[-1].index + 1
			verse.text = koran_loader.quran_db[verse.index]["ayah_ar"]
			
		
	verses.append(verses.pop_front())

func _input(event: InputEvent) -> void:
	if not is_active: return
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	if interrupt_scroll: return
	
	match (event as InputEventKey).keycode:
		KEY_RIGHT:
			
			if scroll_counter > 0:
				scroll_counter = scroll_counter - 1
				await _scroll_up()
			else:
				option_selected.emit("_word_0")

			
		KEY_LEFT:
			if scroll_counter > 0:
				scroll_counter = scroll_counter - 1
				await _scroll_down()
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
