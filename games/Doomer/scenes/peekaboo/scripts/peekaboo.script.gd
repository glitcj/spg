extends Node
class_name _Peekaboo_Script

signal script_finished
signal entered_range
signal exited_range
signal actioned_within_range
signal is_within_range
signal frame_started
signal area_entered_by_player

@export var interrupt_player := false
@export var trigger : ScriptTirgger
@export var action_range : float = 10.0


@onready var peekaboo : _Peekaboo = find_parent("_Peekaboo")
@onready var map : _Peekaboo_Map = find_parent("_Peekaboo_Map")
@onready var lambdas : _Peekaboo_Lambdas = map.find_child("Peekaboo_Lambdas")


func get_peekaboo(): return find_parent("_Peekaboo") as _Peekaboo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _Peekaboo_Player
func get_lambdas(): return find_parent("_Peekaboo_Map").find_child("_Peekaboo_Lambdas") as _Peekaboo_Lambdas
func get_variables(): return _Peekaboo_Variables
func get_area(): return get_parent().find_child("Area2D") as Area2D

"""
	if get_parent().find_child("Area2D"):
	
		return get_parent().find_child("Area2D")
	return find_child("Area2D")
"""

var variables = _Peekaboo_Variables

enum ScriptTirgger {
	Automatic, ActionWithinRange, WithinRange,
	Collision, EnteredRange, ExitedRange
}

var last_distnace_from_player : Vector2 = Vector2.ZERO
var current_distnace_from_player : Vector2 = Vector2.ZERO

# TODO: replace with getters
var parent : Object
var mover : _Peekaboo_Mover
var portrait : _Peekaboo_Portrait
var scene_just_started := true


var trigger_is_running : Dictionary = {}


func _ready():
	_get_components.call_deferred()
	# bind_triggers()
	bind_triggers.call_deferred()
	await get_tree().process_frame
	# _wrapped_callable.bind(_on_scene_start).call_deferred()



func bind_triggers():
	var trigger_callables = [
		_on_within_range, _on_scene_start, 
		_on_entered_range, _on_exited_range,
		_on_action_within_range_trigger,
		_on_frame, _on_area_entered
		]
	for c : Callable in trigger_callables:
		trigger_is_running[c.get_method()] = false
	
	entered_range.connect(_wrapped_callable.bind(_on_entered_range))
	exited_range.connect(_wrapped_callable.bind(_on_exited_range))
	actioned_within_range.connect(_wrapped_callable.bind(_on_action_within_range_trigger))
	is_within_range.connect(_wrapped_callable.bind(_on_within_range))
	frame_started.connect(_wrapped_callable.bind(_on_frame))
	get_peekaboo().scene_started.connect(_wrapped_callable.bind(_on_scene_start))
	
	
	if get_area():

		get_area().body_entered.connect(_check_area_signals)
	area_entered_by_player.connect(_wrapped_callable.bind(_on_area_entered))

	
func _get_components():
	parent = get_parent()
	if parent.find_children("*", "_Peekaboo_Mover").size() > 0:
		mover = parent.find_child("_Peekaboo_Mover")
	if parent.find_children("*", "_Peekaboo_Portrait").size() > 0:
		portrait = parent.find_child("_Peekaboo_Portrait")

func _process(_delta: float):
	if not peekaboo or not peekaboo.map.player:
		return
	_log()
	_check_range_signals()
	frame_started.emit()
	
	if Input.is_action_just_pressed("ui_accept"):
		if _distance_to_player() < action_range:
			
			var player_mover = peekaboo.find_child("Player").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
			var player_is_facing_this_event : bool = mover.map_position == player_mover.get_facing_direction() + player_mover.map_position
			if player_is_facing_this_event:
				actioned_within_range.emit()

	if _distance_to_player() < action_range:
		is_within_range.emit()

func _check_range_signals():
	last_distnace_from_player = current_distnace_from_player
	current_distnace_from_player = peekaboo.map.player.position - parent.position

	if scene_just_started:
		scene_just_started = false
		return

	if last_distnace_from_player.length() >= action_range and current_distnace_from_player.length() < action_range:
		entered_range.emit()

	if last_distnace_from_player.length() <= action_range and current_distnace_from_player.length() > action_range:
		exited_range.emit()



func _check_area_signals(body: Node2D): # Add the 'body' parameter
	if body == get_player(): 
		area_entered_by_player.emit()
		
func _distance_to_player() -> float:
	return (peekaboo.map.player.position - parent.position).length()

func _wrapped_callable(c: Callable):
	if trigger_is_running[c.get_method()]:
		return
	trigger_is_running[c.get_method()] = true

	await c.call()
	
	trigger_is_running[c.get_method()] = false


func _on_scene_start():
	pass

func _on_frame():
	pass

func _on_within_range():
	pass

func _on_action_within_range_trigger():
	pass

func _on_entered_range():
	pass

func _on_exited_range():
	pass

func _on_area_entered():
	pass

func _log():
	pass

func is_running():
	return trigger_is_running.values().any(func(x): return x)
