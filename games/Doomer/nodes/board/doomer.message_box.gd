extends Node2D
class_name _Doomer_Message_Box

signal text_is_fully_displayed

@export var doomer : _Doomer

@onready var label : Label = $"Control/HBoxContainer/Message Box Control/Label"
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var message_box
@onready var message_portrait : _Doomer_Portrait = $Control/HBoxContainer/CenterContainer/Control/Portrait

enum Enumations {ShowNewMessage, ShowLogMessage, ShowDialogueMessage}

var history : Array = []

var full_message_log : Array = []

var message : String:
	set(value):
		message = value
		pass
		# _update_message()

var full_log

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_line(s : String):
	label.text = "\n".join([label.text, s])


func _update_label_as_message():
	label.text = message # "\n".join(full_message_log.slice(-3, 0))


func _update_label_as_log():
	full_message_log.append(message)
	label.text = "\n".join(full_message_log.slice(-1 * min(3, full_message_log.size()), full_message_log.size()))
	pass
	
func show_dialogue(m : String):
	message = m
	play_enumation(Enumations.ShowDialogueMessage)
	
func show_log(m : String):
	message = m
	play_enumation(Enumations.ShowLogMessage)
	
func play_enumation(e : Enumations):
	# assert("ShowLogMessage" in animation_player.get_animation_list())
	animation_player.play(Enumations.keys()[e])
	await animation_player.animation_finished
	
	
