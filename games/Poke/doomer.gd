extends Node
class_name _Poke



@onready var handler : _Poke_Handler = $Handler
@onready var hud : _Doomer_HUD = $HUD
@onready var board : _Doomer_Board = $Board
@onready var player_portrait : _Poke_Portrait = board.player_portrait
@onready var opponent_portrait : _Poke_Portrait = board.opponent_portrait

func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.FoldOrCall

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
