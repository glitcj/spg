extends Node2D

signal text_is_fully_displayed

@onready var label : Label = $Control2/Control/Label

var history : Array = []

var full_message_log : Array = []

var message : String:
	set(value):
		message = value
		_update_message()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_line(s : String):
	label.text = "\n".join([label.text, s])


func _update_message():
	full_message_log.append(message)
	label.text = "\n".join(full_message_log.slice(-3, 0))
