extends Node
class_name _Peekaboo_Script

signal script_finished

@export var peekaboo : _PeekaBoo

var parent : Node2D
var mover : _Peekaboo_Mover
var portrait : _Core_Portrait

enum ScriptTirgger {Automatic, ActionWithinRange, WithinRange, Collision}

@export var trigger : ScriptTirgger
@export var action_range : float

func _ready():
	_get_components.call_deferred()
	
	if trigger == ScriptTirgger.Automatic:
		_on_trigger.call_deferred()
		
func _get_components():
	parent = get_parent()
	
	if parent.find_children("*", "_Peekaboo_Mover").size() > 0:
		mover = parent.find_child("_Peekaboo_Mover")
		
	if parent.find_children("*", "_Core_Portrait").size() > 0:
		portrait = parent.find_child("_Core_Portrait")


func _process(delta : float):
	"""
	if Input.is_action_just_pressed("ui_accept"):
		if (peekaboo.player.position - parent.position).length() < action_range:
			pass
			_on_trigger().call()
	"""
	if not peekaboo:
		return
		
	if not peekaboo.player:
		return
	
	if trigger == ScriptTirgger.ActionWithinRange:
		print("distance ", (peekaboo.player.position - parent.position).length())
		if (peekaboo.player.position - parent.position).length() < action_range:
			_on_trigger()
	
func _on_trigger():
	pass
