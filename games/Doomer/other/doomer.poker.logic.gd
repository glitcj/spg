extends Node
class_name _Doomer_Logic

@onready var doomer : _Core = find_parent("_Core")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func face_up_field_cards() -> Array:
	var cards = []
	for card : _Doomer_Card in doomer.scene.poker_board.field_cards:
		if card.state == _Doomer_Card.CardState.FacingUp:
			cards.append(card)
	return cards
	
	
func calculate_winner() -> _Core.Opponents:
	var enemy_hand_value = 0
	var player_hand_value = 0
	for card : _Doomer_Card in doomer.scene.poker_board.player_cards:
		player_hand_value += card.value # _Doomer_Card.CardValue.keys()[card.value]
		
	for card : _Doomer_Card in doomer.scene.poker_board.enemy_cards:
		enemy_hand_value += card.value # _Doomer_Card.CardValue.keys()[card.value]
	
	if player_hand_value > enemy_hand_value:
		return _Core.Opponents.Player
	else:
		return _Core.Opponents.Enemy
		

func calculate_loser() -> _Core.Opponents:
	if calculate_winner() == _Core.Opponents.Player:
		return _Core.Opponents.Enemy
	else:
		return _Core.Opponents.Player
		


func get_winner_coin_box():
	if calculate_winner() == _Core.Opponents.Player:
		return doomer.scene.poker_board.player_coin_box
	else:
		return doomer.scene.poker_board.enemy_coin_box


"""
class _Doomer_Hand:
	enum HandType {HighCard, Pair, TwoPair, ThreePair, FourPair, Straight, FullHouse, Flush}
	var hand
"""
