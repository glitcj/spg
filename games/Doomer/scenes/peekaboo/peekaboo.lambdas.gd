extends Node
class_name _Peekaboo_Lambdas

@export var doomer : _Doomer

func get_peekaboo(): return find_parent("_PeekaBoo") as _PeekaBoo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _PeekaBoo_Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
"""
func _slide_windows_in():
	for _window : _Doomer_Message_Box in [peekaboo.logger]:
		await _window.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
		await get_tree().create_timer(.1).timeout
		await _window.play_enumation(_Doomer_Message_Box.Enumations.Buzz)
"""


func transport_player(position: Vector2i):
	var mover = get_player().find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	mover.map_position = position

"""
func update_idle_animation():
	var portrait = peekaboo.find_child("Player Portrait") as _Core_Portrait
	if Input.is_action_just_pressed("ui_left"):
		portrait.animation_player.play("move_left")
	elif Input.is_action_just_pressed("ui_right"):
		portrait.animation_player.play("move_right")
	elif Input.is_action_just_pressed("ui_up"):
		portrait.animation_player.play("move_up")
	elif Input.is_action_just_pressed("ui_down"):
		portrait.animation_player.play("move_down")
"""
