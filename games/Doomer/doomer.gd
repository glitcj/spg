extends Node
class_name _Doomer

@onready var handler : _Doomer_Handler = $Handler
@onready var hud : _Doomer_HUD = $Containers/VBoxContainer/HUD
@onready var turner : _Doomer_Turner = $Turner

@onready var board : _Doomer_Board = $Containers/VBoxContainer/Board
@onready var logic : _Doomer_Logic = $Logic
@onready var actions : _Doomer_Actions = $Actions

@onready var player : _Doomer_Opponent = $Opponents/Player
@onready var enemy : _Doomer_Opponent = $Opponents/Enemy

@onready var opponents : Array[_Doomer_Opponent] = [$Opponents/Player, $"Opponents/Enemy"]
@onready var pointers : _Doomer_Pointers = $Pointers


func get_player_and_opponent_cards():
	var __cards = []
	__cards.append_array(player.hand)
	__cards.append_array(enemy.hand)	
	return __cards

func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.Inactive
	# turner.initialise_turn_queue()
