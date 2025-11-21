extends Node
class_name _Doomer_Logic

@onready var doomer : _Doomer = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func face_up_field_cards() -> Array:
	var cards = []
	for card : _Doomer_Card in doomer.board.field_cards:
		if card.state == _Doomer_Card.CardState.FacingUp:
			cards.append(card)
	return cards
