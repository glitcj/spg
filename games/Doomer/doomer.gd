extends Node
class_name _Doomer

@onready var handler : _Doomer_Handler = $Handler
@onready var hud : _Doomer_HUD = $HUD
@onready var turner : _Doomer_Turner = $Turner

@onready var board : _Doomer_Board = $Board
@onready var logic : _Doomer_Logic = $Logic
@onready var actions : _Doomer_Actions = $Actions
# @onready var player_portrait : _Doomer_Portrait = board.player_portrait
# @onready var opponent_portrait : _Doomer_Portrait = board.opponent_portrait

@onready var player : _Doomer_Opponent = $Opponents/Player
@onready var opponents : Array[_Doomer_Opponent] = [$Opponents/Player, $"Opponents/Opponent-A"]
# @onready var enemies : Array[_Doomer_Opponent] = [$"Opponents/Opponent-A"]


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
