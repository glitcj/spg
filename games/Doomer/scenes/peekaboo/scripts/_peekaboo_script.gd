extends Node
class_name _Peekaboo_Script

signal actioned_within_area
signal frame_started
signal area_entered_by_player

@export var interrupt_player := false
@export var action_range : float = 10.0



var this_script_is_running = false

func get_core(): return find_parent("_Core") as _Core
func get_peekaboo(): return find_parent("_Peekaboo") as _Peekaboo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _Peekaboo_Player
func get_lambdas(): return get_map().get_lambdas() as _Peekaboo_Lambdas

func get_variables(): return _Peekaboo_Variables
func get_area(): return get_parent().find_child("Area2D") as Area2D
func get_mover(): return get_parent().find_child("_Peekaboo_Mover") as _Peekaboo_Mover
func get_portrait(): return get_parent().find_child("_Peekaboo_Portrait")

func this_event(): return get_parent() as _Peekaboo_Event

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
	bind_triggers.call_deferred()
	await get_tree().process_frame
	
func bind_triggers():
	var trigger_callables = [
		_on_within_range, _on_scene_start, 
		_on_entered_range, _on_exited_range,
		_on_action_within_area,
		_on_frame, _on_area_entered
		]
	for c : Callable in trigger_callables:
		trigger_is_running[c.get_method()] = false
	
	actioned_within_area.connect(_wrapped_callable.bind(_on_action_within_area))
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
	if not get_peekaboo() or not get_player():
		return
		
	if not get_peekaboo().is_active:
		return
		
	_log()
	frame_started.emit()
	
	if Input.is_action_just_pressed("ui_accept"):
		if _player_is_within_event_area():
			var player_mover = get_player().find_child("_Peekaboo_Mover") as _Peekaboo_Mover
			var player_is_facing_this_event : bool = mover.map_position == player_mover.get_facing_direction() + player_mover.map_position
			if player_is_facing_this_event and get_player().is_active:
				await get_tree().process_frame # wait for input buffer to clear
				actioned_within_area.emit()

func _check_area_signals(body: Node2D): # Add the 'body' parameter
	if body == get_player(): 
		area_entered_by_player.emit()


func _player_is_within_event_area():
	if get_area(): return get_area().overlaps_body(get_player())

func _distance_to_player() -> float:
	return (get_player().position - parent.position).length()
	
func _wrapped_callable(c: Callable):
	# if callable not defined in dict yet
	if c.get_method() not in trigger_is_running.keys():
		trigger_is_running[c.get_method()] = false
		
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

func _on_action_within_area():
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

func _get_direction_to_player():
	var player_position = get_player().find_child("_Peekaboo_Mover").map_position as Vector2i
	var direction = Vector2(player_position - get_mover().map_position).normalized()
	assert(direction.abs().x + direction.abs().y == 1) # make sure direction is in udlr
	return Vector2i(direction)
