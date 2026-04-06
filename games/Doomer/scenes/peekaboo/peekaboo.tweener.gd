extends Node
class_name _Peekaboo_Tweener

@onready var parent = get_parent() as Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _slide_in():
	# var parent = self

	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): parent.visible = true)
	tween.tween_callback(func(): parent.position = Vector2(0, 300))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 0))
	
	tween.tween_property(parent, "position", Vector2.ZERO, slide_duration)
	tween.parallel().tween_property(parent, "modulate", Color(1,1,1,1), 1)

func _slide_out():
	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): parent.position = Vector2(0, 0))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 1))
	
	tween.tween_property(parent, "position", Vector2(0, 300), slide_duration)
	tween.parallel().tween_property(parent, "modulate", Color(1,1,1,0), 1)
	
	await tween.finished
	



func highlight():


	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var duration = .5
	
	tween.tween_callback(func(): parent.position = Vector2(0, 0))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 1))
	
	
	var base_scale = parent.scale as Vector2
	tween.set_loops(1)
	
	var mover = find_parent("Player").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	
	var base_speed = mover.speed
	

	tween.tween_property(parent, "modulate", Color(1,0,1,1), duration)
	tween.parallel().tween_property(parent, "scale", base_scale * 1.2, duration)
	tween.parallel().tween_property(mover, "speed", base_speed * 2, 0.1)
	
	tween.tween_property(parent, "modulate", Color(1,1,1,1), duration)
	tween.parallel().tween_property(parent, "scale", base_scale, duration)
	tween.parallel().tween_property(mover, "speed", base_speed, 0.1)
