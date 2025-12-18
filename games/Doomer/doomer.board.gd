extends Node
class_name _Doomer_Board

@onready var doomer : _Doomer = get_parent()
# @onready var field_cards # : Array = doomer.board_container.field_cards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# field_cards = doomer.board_container.field_cards
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flip_next_field_card():
	for card : _Doomer_Card in doomer.field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			await card.flip_up()
			break
			
func all_cards_are_up():
	for card : _Doomer_Card in doomer.field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return false
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
	for card : _Doomer_Card in doomer.field_cards:
		card.set_random_card_value_and_suite()
	return true

"""

func get_player_and_enemy_cards():
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
	__cards.append_array(doomer.enemy.hand)
	return __cards
"""


func get_player_and_enemy_cards():
	var __cards = []
	__cards.append_array(doomer.player_cards)
	__cards.append_array(doomer.enemy_cards)	
	return __cards


func get_player_cards():
	return doomer.player_cards

func get_enemy_cards():
	return doomer.enemy_cards


func get_next_field_card():
	for card : _Doomer_Card in doomer.field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return [card]
	return null
	
func get_field_cards():
	return doomer.field_cards
	
func get_highest_player_or_enemy_card():
	return doomer.field_cards[0]
		
func get_flop_cards():
	return doomer.field_cards.slice(0, 3)
	
func get_all_cards():
	var all_cards = []
	all_cards.append_array(get_field_cards())
	all_cards.append_array(get_player_cards())
	all_cards.append_array(get_enemy_cards())
	return all_cards
