extends Node2D
class_name _Doomer_Message_Box


signal finished

@onready var doomer : _Core = find_parent("_Core")

# Settings
@export var visible_on_reset = false

@onready var label : Label = find_child("Message Label")
@onready var animation_player : AnimationPlayer = find_child("AnimationPlayer")
@onready var message_portrait : _Doomer_Portrait = find_child("Message Portrait")
@onready var message_box

@onready var tweener = %_Peekaboo_Tweener

enum Action {ShowLog, ShowMessage, Buzz}
enum Enumations {ShowNewMessage, ShowLogMessage, 
	ShowDialogueMessage, Idle, Buzz,
	SlideInFromLeft, SlideInFromRight,
	SlideOutToLeft, SlideOutToRight
	}

var history : Array = []
var full_message_log : Array = []

var is_active = false

var message_queue = []
var processed_messages = []

var message : String:
	set(value):
		message = value
		
var visible_message : String:
	set(value):
		label.text = value
		visible_message = value
		
var full_log

func _process(delta: float) -> void:
	_process_input()
	# _check_is_active()

func add_line(s : String):
	label.text = "\n".join([label.text, s])


"""
func _check_is_active():
	is_active = true
	if get_parent() is _Core_Scene:
		if not (get_parent() as _Core_Scene).is_active:
			is_active = false
"""

func _update_label_as_message():
	label.text = message # "\n".join(full_message_log.slice(-3, 0))
	
func _update_label_as_log():
	full_message_log.append(message)
	label.text = "\n".join(full_message_log.slice(-1 * min(3, full_message_log.size()), full_message_log.size()))
	
func start(m : Array):
	tweener._slide_in()
	message_queue = m
	_show_next_message()
	
	# Defer setting is_active to run after _process_input()
	# _process_input() should ignore inputs in this frame
	var lambda = func(): visible = true
	lambda.call_deferred()

	return finished


func _show_current_message(m):
	message = m
	await play_enumation(Enumations.ShowDialogueMessage)


func _show_next_message():
	if message_queue == []:
		if visible:
			await tweener._slide_out()
			visible = false
			finished.emit()
		return
		
	message = message_queue.pop_front()
	print(message)
	_show_current_message(message)
	processed_messages.append(message)


func _process_input():
	if not is_active:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		_show_next_message()

func show_log(m : String):
	message = m
	play_enumation(Enumations.ShowLogMessage)
	
func play_enumation(e : Enumations):
	animation_player.play(Enumations.keys()[e])
	await animation_player.animation_finished

func _on_reset():
	%"Animated Node".visible = visible_on_reset
