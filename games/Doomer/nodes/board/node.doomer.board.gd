extends Node2D
class_name _Doomer_Board

@onready var doomer : _Doomer = get_parent().get_parent().get_parent()

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
	for i  in range(field_cards.size()):
		var card : _Doomer_Card = field_cards[i]
		var is_last_card = i == field_cards.size() - 1
		card.state = state_
		
		if state_ == _Doomer_Card.CardState.FacingUp:
			if is_last_card:
				await card.flip_up()
			else:
				card.flip_up()
		else:
			if is_last_card:
				await card.flip_down()
			else:
				card.flip_down()
				
	return true
	
func flip_cards(cards_ : Array, direction : Variant = null, wait_for_each_flip : bool = true):
	if cards_ == []:
		return
		
	for i in range(cards_.size()):
		var card : _Doomer_Card = cards_[i]
		print("aaaaa ", i, " ", cards_.size() - 1)
		if not wait_for_each_flip and i < cards_.size() - 1:
			card.flip(direction, false)
		else:
			await card.flip(direction, true)
		

func randomise_cards(cards_):
	for card : _Doomer_Card in cards_:
		card.set_random_card_value_and_suite()

func randomise_all_field_cards():
	for card : _Doomer_Card in field_cards:
		card.set_random_card_value_and_suite()
	return true




func get_player_and_opponent_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	__cards.append_array(doomer.enemy.hand)	
	return __cards
	
func get_player_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	return __cards

func get_enemy_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	return __cards



func get_next_field_card():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return card
	return null
	
func get_field_cards():
	return field_cards
	
func get_highest_player_or_enemy_card():
	return field_cards


"""
func get_field_cards():
	return board.get_field_cards()
	
func get_highest_player_or_enemy_card():
	return board.get_highest_player_or_enemy_card()
	
func get_next_field_card():
	return board.next_field_card()
"""
