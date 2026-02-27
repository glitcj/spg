extends Node
class_name _Doomer_Getters_Board

@onready var doomer : _Doomer = get_parent()

func all_cards_are_up():
	for card : _Doomer_Card in doomer.field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return false
	return true

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

func get_last_flipped_field_card():
	var first_card : _Doomer_Card = doomer.field_cards[0]
	if first_card.state == _Doomer_Card.CardState.FacingDown:
		return null
	
	var counter = 1
	var last_inspected_card = doomer.field_cards[0]
	for card : _Doomer_Card in doomer.field_cards.slice(1, doomer.field_cards.size()):
		if card.state == _Doomer_Card.CardState.FacingDown:
			return [last_inspected_card]
		
		# If this is the last card on the field.
		if counter == doomer.field_cards.size() - 1:
			return [card]
			
		last_inspected_card = card
		counter += 1
	
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
