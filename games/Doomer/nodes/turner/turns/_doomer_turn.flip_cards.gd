extends _Doomer_Turn
class_name _Doomer_Turn_Flip_Cards

var cards : Array = []

func _init(cards_: Array = []) -> void:
	turn_name = "Flip"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Flip_Next_Field_Card"
	turn_wait_time = 2
	cards = cards_

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	await doomer.board.flip_cards(cards)
	doomer.turner.turner_timer.paused = false
	return

func on_turn_end():
	pass
