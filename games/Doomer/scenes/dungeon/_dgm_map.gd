extends Node3D
class_name Dungeon_Map

signal finished

var TIME = 0.

func _get_viewport(): return find_parent("_Desert") as _Desert

func _ready():
	pass
	print_tree_pretty()
	
	_get_viewport().started.connect(_on_viewport_started)
	pass

func _on_viewport_started():
	%_Desert_Player.global_position = %_player_position.global_position
	await get_tree().process_frame
	%_Desert_Player.is_active = false
	pass

func input(): pass # async
func _process_echoed_input(): pass # syncs with process frame
func _process_muted_input(): pass # syncs with process frame
func _process_physics_input(): pass # syncs with physics frame

func _process_input() -> void:
	#$ if not _get_viewport().is_active: return
	_process_echoed_input()
	_process_muted_input()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_time(delta)
	_process_input()

func _physics_process(delta: float) -> void:
	_process_physics_input()

func _update_time(delta: float):
	TIME += delta
