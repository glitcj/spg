extends _Doomer_Turn
class_name _Doomer_Turn_Action_Cards

var cards_pointer : _Doomer_Pointer
var card_action : _Doomer_Card.CardActions
var wait_for_each_action : bool = false

func _init(cards_pointer_: _Doomer_Pointer, card_action_ : _Doomer_Card.CardActions, wait_for_each_action_ : bool = false) -> void:
	turn_name = "Act"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Action_Cards"
	turn_wait_time = 1
	cards_pointer = cards_pointer_
	wait_for_each_action = wait_for_each_action_
	card_action = card_action_
	

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	var cards : Array = cards_pointer.grab()
	print(cards)
	for card : _Doomer_Card in cards:
		await card.action(card_action)
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
