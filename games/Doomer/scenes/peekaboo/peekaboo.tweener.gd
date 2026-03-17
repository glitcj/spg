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
	



func highlight():


	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var duration = .5
	
	tween.tween_callback(func(): parent.position = Vector2(0, 0))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 1))
	
	
	var base_scale = parent.scale as Vector2
	tween.set_loops(3)
	
	tween.tween_property(parent, "modulate", Color(1,0,1,1), duration)
	tween.parallel().tween_property(parent, "scale", base_scale * 1.2, duration)
	
	
	tween.tween_property(parent, "modulate", Color(1,1,1,1), duration)
	tween.parallel().tween_property(parent, "scale", base_scale, duration)
	


func correct_position():
	
	var map = find_parent("_Peekaboo_Map") as _Peekaboo_Map
	var layer = map.l1 as TileMapLayer
	var mover = find_parent("Player").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	
	var unsynced_map_position = mover.get_map_position()
	var target_global_position = layer.to_global(layer.map_to_local(unsynced_map_position))
	

	var tween = parent.create_tween()
	var player = find_parent("Player") as _PeekaBoo_Player

	var duration = .2
	tween.tween_property(find_parent("Player"), "global_position", target_global_position, duration)
	
	# Doesnt work because it fights with move_and_collide which forces xy of the global position
	"""
	if player.direction in ["ui_down", "ui_up"]:
		tween.tween_property(find_parent("Player"), "global_position.x", target_global_position.x, duration)
	elif player.direction in ["ui_left", "ui_right"]:
		tween.tween_property(find_parent("Player"), "global_position.y", target_global_position.y, duration)
	"""
