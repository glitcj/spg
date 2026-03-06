extends Node2D
class_name _Doomer_Message_Box


@export var doomer : _Doomer

# Settings
@export var visible_on_reset = false

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

func add_line(s : String):
	label.text = "\n".join([label.text, s])


func _update_label_as_message():
	label.text = message # "\n".join(full_message_log.slice(-3, 0))


func _update_label_as_log():
	full_message_log.append(message)
	label.text = "\n".join(full_message_log.slice(-1 * min(3, full_message_log.size()), full_message_log.size()))
	
func _slide_in():
	var parent = self

	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): parent.position = Vector2(0, 300))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 0))
	
	tween.tween_property(parent, "position", Vector2.ZERO, slide_duration)
	tween.parallel().tween_property(parent, "modulate", Color(1,1,1,1), 1)

func _slide_out():
	var parent = self

	var tween = parent.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var slide_duration = .5
	
	tween.tween_callback(func(): parent.position = Vector2(0, 0))
	tween.tween_callback(func(): parent.modulate = Color(1, 1, 1, 1))
	
	tween.tween_property(parent, "position", Vector2(0, 300), slide_duration)
	tween.parallel().tween_property(parent, "modulate", Color(1,1,1,0), 1)
	





func start(m):
	is_active = true
	_slide_in()
	if m is String:
		_show_current_message(m)
	elif m is Array:
		message_queue = m
		_show_next_message()


func _show_current_message(m):
	message = m
	await play_enumation(Enumations.ShowDialogueMessage)


func _show_next_message():
	if message_queue == []:
		if is_active:
			_slide_out()
			is_active = false
		return
		
	message = message_queue.pop_front()
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
