extends Node
class_name _Core

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

# enum Opponents {Player, Enemy}

var current_scene : _Core_Scene

@onready var camera = %Camera2D as Camera2D
@onready var turner : _Core_Turner = $Turner


func get_scene(_name): return find_child(_name) as _Core_Scene
func get_lambdas(): return find_child("_Core_Lambdas") as _Core_Lambdas



func _input(event):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_boot.call_deferred()

func _boot():
	change_scene(get_scene("_Starter"))
	
	
func change_scene(scene_: _Core_Scene):
	if current_scene:
		await current_scene._on_scene_end()
		
	current_scene = scene_
	camera.reparent(current_scene)
	camera.position = Vector2.ZERO
	await scene_._on_scene_start()
