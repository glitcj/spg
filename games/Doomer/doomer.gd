extends Node
class_name _Doomer

@onready var handler : _Doomer_Handler = $Handler
@onready var hud : _Doomer_HUD = $Control/VBoxContainer/HUD
@onready var turner : _Doomer_Turner = $Turner

@onready var board : _Doomer_Board = $Control/VBoxContainer/Board
@onready var logic : _Doomer_Logic = $Logic
@onready var actions : _Doomer_Actions = $Actions

@onready var player : _Doomer_Enemy = $Opponents/Player
@onready var opponents : Array[_Doomer_Enemy] = [$Opponents/Player, $"Opponents/Enemy"]


func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.Inactive
	turner.initialise_turn_queue()
	
	# TODO: Replace with array logic
	# board.player_portrait = player.portrait
	# board.opponent_portrait = $"Opponents/Opponent-A".portrait

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
