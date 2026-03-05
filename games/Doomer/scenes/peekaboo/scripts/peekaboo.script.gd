extends Node
class_name _Peekaboo_Script

signal script_finished

@export var peekaboo : _PeekaBoo

signal entered_range
signal exited_range

var last_distnace_from_player : Vector2 = Vector2.ZERO
var current_distnace_from_player : Vector2 = Vector2.ZERO

var parent : Node2D
var mover : _Peekaboo_Mover
var portrait : _Core_Portrait

var scene_just_started = true

enum ScriptTirgger {
	Automatic, ActionWithinRange, WithinRange, 
	Collision, EnteredRange, ExitedRange
	}

@export var trigger : ScriptTirgger
@export var action_range : float = 10.0

func _ready():
	_get_components.call_deferred()
	_on_automatic.call_deferred()
		
func _get_components():
	parent = get_parent()
	
	if parent.find_children("*", "_Peekaboo_Mover").size() > 0:
		mover = parent.find_child("_Peekaboo_Mover")
		
	if parent.find_children("*", "_Core_Portrait").size() > 0:
		portrait = parent.find_child("_Core_Portrait")


func _check_range_signals():
	last_distnace_from_player = current_distnace_from_player
	current_distnace_from_player = peekaboo.player.position - parent.position
	
	print(action_range, last_distnace_from_player,  current_distnace_from_player)
	
	if scene_just_started:
		scene_just_started = false
		return
		
	if last_distnace_from_player.length() >= action_range and  current_distnace_from_player.length() < action_range:
		entered_range.emit()
		
	if last_distnace_from_player.length() <= action_range and  current_distnace_from_player.length() > action_range:
		exited_range.emit()
	

func _process(delta : float):
	if not peekaboo or not peekaboo.player:
		return
	
	_log()

	_check_range_signals()
	
	entered_range.connect(_on_entered_range)
	exited_range.connect(_on_exited_range)
	
	if Input.is_action_just_pressed("ui_accept"):
		if (peekaboo.player.position - parent.position).length() < action_range:
			_on_action_within_range_trigger()
				
	if (peekaboo.player.position - parent.position).length() < action_range:
		_on_within_range()
	
func _on_action_within_range_trigger():
	pass
	
func _on_entered_range():
	pass
	
func _on_exited_range():
	pass

func _on_within_range():
	pass
	
func _on_automatic():
	pass

func _log():
	print("distance ", (peekaboo.player.position - parent.position).length())
