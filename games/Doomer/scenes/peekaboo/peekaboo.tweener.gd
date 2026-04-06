extends Node
class_name _Peekaboo_Tweener

@onready var parent = get_parent() as Node2D

func _slide_in(tweenee : Node2D):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): tweenee.visible = true)
	tween.tween_callback(func(): tweenee.position = Vector2(0, 300))
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 0))
	
	tween.tween_property(parent, "position", Vector2.ZERO, slide_duration)
	tween.parallel().tween_property(tweenee, "modulate", Color(1,1,1,1), 1)

func _slide_out(tweenee : Node2D):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): tweenee.position = Vector2(0, 0))
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 1))
	
	tween.tween_property(tweenee, "position", Vector2(0, 300), slide_duration)
	tween.parallel().tween_property(tweenee, "modulate", Color(1,1,1,0), 1)
	
	await tween.finished
	
func highlight(tweenee : Node2D):
	var tween = tweenee.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var duration = .5
	
	tween.tween_callback(func(): tweenee.position = Vector2(0, 0))
	tween.tween_callback(func(): tweenee.modulate = Color(1, 1, 1, 1))
	
	
	var base_scale = tweenee.scale as Vector2
	tween.set_loops(1)
	
	var mover = find_parent("_Peekaboo").find_child("Player").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	var base_speed = mover.speed
	

	tween.tween_property(tweenee, "modulate", Color(1,0,1,1), duration)
	tween.parallel().tween_property(tweenee, "scale", base_scale * 1.2, duration)
	tween.parallel().tween_property(mover, "speed", base_speed * 2, 0.1)
	
	tween.tween_property(tweenee, "modulate", Color(1,1,1,1), duration)
	tween.parallel().tween_property(tweenee, "scale", base_scale, duration)
	tween.parallel().tween_property(mover, "speed", base_speed, 0.1)
