extends Node
class_name _Poke


@onready var player_portrait : _Poke_Portrait = $Board/PanelContainer/VBoxContainer/Bottom/FaceMarginContainer/Control/PlayerPortrait
@onready var opponent_portrait : _Poke_Portrait = $Board/PanelContainer/VBoxContainer/Top/FaceMarginContainer/Control/OpponentPortrait
@onready var handler : _Poke_Handler = $Handler


func _input(event):
	handler.handle_inputs(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handler.mode = handler.InputMode.FoldOrCall

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
