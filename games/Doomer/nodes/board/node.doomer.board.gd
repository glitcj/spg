extends Node2D
class_name _Doomer_Board

@export var player : _Doomer_Opponent
@export var opponent_A : _Doomer_Opponent

@onready var player_portrait : _Doomer_Portrait = $PanelContainer/VBoxContainer/Bottom/FaceMarginContainer/CenterContainer/PlayerPortrait
@onready var opponent_portrait : _Doomer_Portrait = $PanelContainer/VBoxContainer/Top/FaceMarginContainer/CenterContainer/OpponentPortrait

@onready var field_cards : Array[_Doomer_Card] = [
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-1/CenterContainer/Card-1",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-2/CenterContainer/Card-2",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-3/CenterContainer/Card-3",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-4/CenterContainer/Card-4",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-5/CenterContainer/Card-5",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# player_portrait = player.portrait
	# opponent_portrait = opponent_A.portrait
	
	
	$PanelContainer/VBoxContainer/Bottom/FaceMarginContainer/CenterContainer.add_child(player.portrait)
	$PanelContainer/VBoxContainer/Top/FaceMarginContainer/CenterContainer.add_child(opponent_A.portrait)
	# $PanelContainer/VBoxContainer/Bottom/FaceMarginContainer/CenterContainer/PlayerPortrait = player.portrait
	# $PanelContainer/VBoxContainer/Top/FaceMarginContainer/CenterContainer/OpponentPortrait = opponent_A.portrait

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
