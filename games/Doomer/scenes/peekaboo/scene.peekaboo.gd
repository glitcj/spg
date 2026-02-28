extends Node
class_name _PeekaBoo

@onready var logger = %"Message Box Logger" as _Doomer_Message_Box

@onready var lambdas = %Lambdas as _PeekaBoo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await lambdas._slide_windows_in()
	"""
	for _message_box : _Doomer_Message_Box in [logger]:
		await _message_box.play_enumation(_Doomer_Message_Box.Enumations.Buzz)
	"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
