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
