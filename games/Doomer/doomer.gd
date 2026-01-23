extends Node
class_name _Doomer

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

enum Opponents {Player, Enemy}
enum Scenes {PokerRound, StartScreen, WorldMap}

var scene : Scenes = Scenes.PokerRound

@onready var handler : _Doomer_Handler = $Handler
@onready var hud : _Doomer_HUD = find_child("HUD Box") # $Containers/BoardContainer/PanelContainer/VBoxContainer/HUD/HUDContainer/CenterContainer/HUD  # $Containers/VBoxContainer/HUDContainer
@onready var turner : _Doomer_Turner = $Turner

@onready var board_container : _Doomer_Board_Container = $Containers/VBoxContainer/BoardContainer
@onready var board : _Doomer_Board = $Board
@onready var logic : _Doomer_Logic = $Logic


@export var player_gun : _Doomer_Gun
@export var enemy_gun : _Doomer_Gun

@onready var field_cards : Array = 	find_children("Field Card *")
@onready var enemy_cards : Array = enemy_gun.hand_cards
@onready var player_cards : Array = player_gun.hand_cards

@onready var player : _Doomer_Opponent = $Opponents/Player
@onready var enemy : _Doomer_Opponent = $Opponents/Enemy

@onready var opponents : Array[_Doomer_Opponent] = [$Opponents/Player, $"Opponents/Enemy"]
@onready var pointer : _Doomer_Pointer = $Pointer

@onready var next_field_card : _Doomer_Card

# @onready var player_coin_box : _Doomer_Coin_Box = player_gun.coin_box
# @onready var enemy_coin_box : _Doomer_Coin_Box = enemy_gun.coin_box
@onready var player_coin_box : _Doomer_Coin_Box = find_child("Player CoinBox")
@onready var enemy_coin_box : _Doomer_Coin_Box = find_child("Enemy CoinBox")


@onready var player_portrait : _Doomer_Portrait = find_child("Player Head")
@onready var enemy_portrait : _Doomer_Portrait = find_child("Enemy Head")

func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.Inactive
	
func make_pointer(key : _Doomer_Pointer.Keys):
	var pointer_ = _Doomer_Pointer.new(key)
	add_child(pointer_)
	return pointer_
