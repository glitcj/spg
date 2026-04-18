extends Node
class_name _Core

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

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
	
func add_scene(parent_scene : _Core_Scene, child_scene: _Core_Scene):
	if parent_scene == current_scene:
		await current_scene._on_scene_end()
	current_scene = child_scene
	
	var wrapper_node = Node2D.new()
	wrapper_node.name = "_Wrapper_"
	wrapper_node.add_child(child_scene)
	wrapper_node.scale = Vector2(0.5, 0.5)
	parent_scene.add_child(wrapper_node)
	
	await child_scene._on_scene_start()


func remove_scene(parent_scene : _Core_Scene, child_scene: _Core_Scene):
	if child_scene == current_scene:
		await child_scene._on_scene_end()
	current_scene = parent_scene

	var wrapper_node = child_scene.get_parent() as Node2D
	parent_scene.remove_child(wrapper_node)
	wrapper_node.remove_child(child_scene)
	wrapper_node.queue_free()
	
	await parent_scene._on_scene_start()
