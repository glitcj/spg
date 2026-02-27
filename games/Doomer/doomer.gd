extends Node
class_name _Doomer

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

enum Opponents {Player, Enemy}

var current_scene_node : _Doomer_Scene

@onready var camera = %Camera2D as Camera2D
@onready var handler : _Doomer_Handler = $Handler
@onready var turner : _Doomer_Turner = $Turner
@onready var logic : _Doomer_Logic = $Logic
@onready var getter : _Doomer_Getter = $Getter
@onready var scene_grid = find_child("Scene Grid")
@onready var current_scene_container = find_child("Current Scene Container")
@onready var lambdas : _Doomer_Lambdas = find_child("Lambdas")



var current_opponent : _Doomer_Opponent



func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.Active

	scene.world_map = %"World Map Scene"
	scene.poker_board = %"Poker Board Scene"
	scene.start_screen = %"Start Sceen Scene"
	
	_boot.call_deferred()

func _boot():
	change_scene(scene.start_screen)



func change_scene(scene_: _Doomer_Scene):
	if current_scene_node:
		current_scene_node._on_scene_end()

	scene_._on_scene_start()

	current_scene_node = scene_
	camera.reparent(current_scene_node)
	camera.position = Vector2.ZERO
	
	
var scene = _Scene.new()
class _Scene:
	var world_map : _Doomer_Scene_World_Map
	var poker_board : _Doomer_Scene_Poker_Board
	var start_screen : _Doomer_Scene_Start_Screen
