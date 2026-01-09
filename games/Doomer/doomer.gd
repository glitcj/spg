extends Node
class_name _Doomer

# Orchestrator
# This class assigns all the static objects that are cross-referenced across objects
# This include nodes, and things inside nodes.
# Static here means that the object does not change throughout the game, and a Pointer is not needed (for example containers)

enum Opponents {Player, Enemy}

@onready var handler : _Doomer_Handler = $Handler
@onready var hud : _Doomer_HUD = $Containers/VBoxContainer/HUDContainer
@onready var turner : _Doomer_Turner = $Turner

@onready var board_container : _Doomer_Board_Container = $Containers/VBoxContainer/BoardContainer
@onready var board : _Doomer_Board = $Board
@onready var logic : _Doomer_Logic = $Logic


# @onready var field_cards = board_container.field_cards
@onready var field_cards : Array[_Doomer_Card] = [
	$"Field/Field Card 1",
	$"Field/Field Card 2",
	$"Field/Field Card 3",
	$"Field/Field Card 4",
	$"Field/Field Card 5",
]


@onready var enemy_cards : Array[_Doomer_Card] = [
$"Opponents/Enemy/Enemy Card 1",
$"Opponents/Enemy/Enemy Card 2",
]

@onready var player_cards : Array[_Doomer_Card] = [
$"Opponents/Player/Player Card 1",
$"Opponents/Player/Player Card 2",
]


@onready var player : _Doomer_Opponent = $Opponents/Player
@onready var enemy : _Doomer_Opponent = $Opponents/Enemy

@onready var opponents : Array[_Doomer_Opponent] = [$Opponents/Player, $"Opponents/Enemy"]
@onready var pointer : _Doomer_Pointer = $Pointer

@onready var next_field_card : _Doomer_Card

@onready var player_coin_box : _Doomer_Coin_Box = $"Portraits/Coins/Player CoinBox"
@onready var enemy_coin_box : _Doomer_Coin_Box = $"Portraits/Coins/Enemy CoinBox"

@onready var player_portrait : _Doomer_Portrait = $"Portraits/Player Head"
@onready var enemy_portrait : _Doomer_Portrait = $"Portraits/Enemy Head"

func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.Inactive
	
func make_pointer(key : _Doomer_Pointer.Keys):
	var pointer_ = _Doomer_Pointer.new(key)
	add_child(pointer_)
	return pointer_
