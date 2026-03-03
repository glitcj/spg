extends Node
class_name _PeekaBoo_Lambdas

@export var doomer : _Doomer

@onready var peekaboo = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _slide_windows_in():
	for _window : _Doomer_Message_Box in [peekaboo.logger]:
		await _window.play_enumation(_Doomer_Message_Box.Enumations.SlideInFromLeft)
		await get_tree().create_timer(.1).timeout
		await _window.play_enumation(_Doomer_Message_Box.Enumations.Buzz)


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
