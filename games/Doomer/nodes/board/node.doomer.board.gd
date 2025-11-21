extends Node2D
class_name _Doomer_Board

@export var player : _Doomer_Opponent
@export var opponent : _Doomer_Opponent
@onready var player_portrait_container = $PanelContainer/VBoxContainer/Bottom/FaceMarginContainer/CenterContainer
@onready var opponent_portrait_container =  $PanelContainer/VBoxContainer/Top/FaceMarginContainer/CenterContainer

@onready var player_hand_containers  =  [
	$"PanelContainer/VBoxContainer/Bottom/CardsMarginContainer-1/CenterContainer",
	$"PanelContainer/VBoxContainer/Bottom/CardsMarginContainer-2/CenterContainer"
]
@onready var opponent_hand_containers = [
	$"PanelContainer/VBoxContainer/Top/CardsMarginContainer-1/CenterContainer",
	$"PanelContainer/VBoxContainer/Top/CardsMarginContainer-2/CenterContainer"
]

@onready var field_cards : Array[_Doomer_Card] = [
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-1/CenterContainer/Card-1",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-2/CenterContainer/Card-2",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-3/CenterContainer/Card-3",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-4/CenterContainer/Card-4",
	$"PanelContainer/VBoxContainer/Field/CardsMarginContainer-5/CenterContainer/Card-5",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_portrait_container.add_child(player.portrait)
	opponent_portrait_container.add_child(opponent.portrait)
	
	
	for i in range(len(player.hand)):
		player_hand_containers[i].add_child(player.hand[i])
		opponent_hand_containers[i].add_child(opponent.hand[i])
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

func flip_next_field_card():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			await card.flip_up()
			break

func all_cards_are_up():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return false
	return true


func flip_all_field_cards(state_ : _Doomer_Card.CardState):
	for card : _Doomer_Card in field_cards:
		# card.state = state_
		if state_ == _Doomer_Card.CardState.FacingUp:
			await card.flip_up()
		else:
			await card.flip_down()
	return true
	
func randomise_all_field_cards():
	for card : _Doomer_Card in field_cards:
		card.set_random_card_value_and_suite()
	return true
