extends Node
class_name _Doomer

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

enum Opponents {Player, Enemy}
enum DoomerScene {PokerBoard, StartScreen, WorldMap, Null}

var current_scene : DoomerScene = DoomerScene.Null
var current_scene_node : Node

@onready var camera = %Camera2D as Camera2D
@onready var handler : _Doomer_Handler = $Handler
@onready var turner : _Doomer_Turner = $Turner
@onready var board : _Doomer_Getters_Board = $Board
@onready var logic : _Doomer_Logic = $Logic
@onready var getter : _Doomer_Getter = $Getter

@onready var scene_grid = find_child("Scene Grid")
@onready var current_scene_container = find_child("Current Scene Container")
@onready var hud : _Doomer_HUD = find_child("Poker Board Scene").find_child("HUD")
@onready var player_gun : _Doomer_Gun = find_child("Player Gun")
@onready var enemy_gun : _Doomer_Gun = find_child("Enemy Gun")
@onready var field_cards : Array = 	find_children("Field Card *")
@onready var player_coin_box : _Doomer_Coin_Box = find_child("Player CoinBox")
@onready var enemy_coin_box : _Doomer_Coin_Box = find_child("Enemy CoinBox")
@onready var player_portrait : _Doomer_Portrait = find_child("Player Head")
@onready var enemy_portrait : _Doomer_Portrait = find_child("Enemy Head")
@onready var lambdas : _Doomer_Lambdas = find_child("Lambdas")

@onready var enemy_cards : Array = enemy_gun.hand_cards
@onready var player_cards : Array = player_gun.hand_cards
@onready var next_field_card : _Doomer_Card
@onready var current_opponent : _Doomer_Opponent


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
	change_scene(DoomerScene.StartScreen)


func change_scene(scene_ = _Doomer.DoomerScene):
	var scene_tscn : _Doomer_Scene
	if scene_ == _Doomer.DoomerScene.PokerBoard:
		scene_tscn = find_child("Poker Board Scene")
	if scene_ == _Doomer.DoomerScene.StartScreen:
		scene_tscn = find_child("Start Sceen Scene")
	if scene_ == _Doomer.DoomerScene.WorldMap:
		scene_tscn = find_child("World Map Scene")
	
	if current_scene_node:
		current_scene_node._on_scene_end()

	scene_tscn._on_scene_start()
	
	current_scene = scene_
	current_scene_node = scene_tscn as _Doomer_Scene
	camera.reparent(current_scene_node)
	camera.position = Vector2.ZERO
	
	
var scene = _Scene.new()
class _Scene:
	var world_map : _Doomer_Scene_World_Map
	var poker_board : _Doomer_Scene_Poker_Board
	var start_screen : _Doomer_Scene_Start_Screen
