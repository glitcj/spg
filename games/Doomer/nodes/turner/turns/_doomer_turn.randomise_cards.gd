extends _Doomer_Turn
class_name _Doomer_Turn_Randomise_Cards

var cards_and_pointers : Array = []


func _init(cards_and_pointers_: Array = []) -> void:
	turn_name = "Randomise"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Flip_Next_Field_Card"
	turn_wait_time = .2
	cards_and_pointers = cards_and_pointers_
	
func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	
	var cards : Array = _Doomer_Pointer.unpack_and_flatten(cards_and_pointers)
	print(cards)
	
	doomer.turner.turner_timer.paused = true
	await doomer.board.randomise_cards(cards)
	doomer.turner.turner_timer.paused = false
	return

func on_turn_end():
	pass
