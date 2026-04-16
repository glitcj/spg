extends Node
class_name _Core_Tweener

var displacement = 300

func set_displacement(v):
	displacement = v
	return self

static func _slide_in(tweenee : Node, duration := 0.5, vector = Vector2i(0, 1)):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	
	var _disaplacement = 300 # pixels
	
	tween.tween_callback(func(): tweenee.position = vector * _disaplacement)
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 0))
	tween.tween_callback(func(): tweenee.visible = true)

	
	tween.tween_property(tweenee, "position", Vector2.ZERO, duration)
	tween.parallel().tween_property(tweenee, "modulate", Color(1,1,1,1), duration)
	await tween.finished

static func _slide_out(tweenee : Node, duration := 0.5, vector = Vector2i(0, 1)):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(func(): tweenee.position = Vector2(0, 0))
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 1))
	
	var _disaplacement = 300
	tween.tween_property(tweenee, "position", Vector2(vector * _disaplacement), duration)
	tween.parallel().tween_property(tweenee, "modulate", Color(1,1,1,0), duration)
	tween.tween_callback(func(): tweenee.visible = false)
	
	await tween.finished
	
static func highlight(tweenee : Node2D):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var duration = .5
	
	tween.tween_callback(func(): tweenee.position = Vector2(0, 0))
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 1))
	
	
	var base_scale = tweenee.scale as Vector2
	tween.set_loops(1)
	
	var mover = tweenee.find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	var base_speed = mover.speed
	

	tween.tween_property(tweenee, "modulate", Color(1,0,1,1), duration)
	tween.parallel().tween_property(tweenee, "scale", base_scale * 1.2, duration)
	tween.parallel().tween_property(mover, "speed", base_speed * 2, 0.1)
	
	tween.tween_property(tweenee, "modulate", Color(1,1,1,1), duration)
	tween.parallel().tween_property(tweenee, "scale", base_scale, duration)
	tween.parallel().tween_property(mover, "speed", base_speed, 0.1)
