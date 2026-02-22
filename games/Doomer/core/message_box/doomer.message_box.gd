extends Node2D
class_name _Doomer_Message_Box

@export var doomer : _Doomer

@onready var label : Label = find_child("Message Label")
@onready var animation_player : AnimationPlayer = find_child("AnimationPlayer")
@onready var message_portrait : _Doomer_Portrait = find_child("Message Portrait")
@onready var message_box

enum Action {ShowLog, ShowMessage, Buzz}
enum Enumations {ShowNewMessage, ShowLogMessage, 
	ShowDialogueMessage, Idle, Buzz,
	SlideInFromLeft, SlideInFromRight,
	SlideOutToLeft, SlideOutToRight
	}

var history : Array = []
var full_message_log : Array = []

var message : String:
	set(value):
		message = value
		pass

var full_log

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
	animation_player.play(Enumations.keys()[e])
	await animation_player.animation_finished
