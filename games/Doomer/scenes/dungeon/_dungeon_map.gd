extends Node3D
class_name Dungeon_Map

var TIME = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_time(delta)
	%Camera3D.position.x += sin(TIME/10) * .01

func _update_time(delta: float):
	TIME += delta * 10
