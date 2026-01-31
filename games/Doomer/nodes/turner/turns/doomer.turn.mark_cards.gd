extends _Doomer_Turn
class_name _Doomer_Turn_Mark_Cards

var cards_pointer : _Doomer_Pointer
var mark_type : _Doomer_Card_Mark.MarkType
var wait_for_each_mark : bool = false
var opponent : _Doomer.Opponents

func _init(cards_pointer_: _Doomer_Pointer, mark_type_ : _Doomer_Card_Mark.MarkType, opponent_ : Variant = null, wait_for_each_mark_ : bool = false) -> void:
	turn_name = "Mark"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Mark_Cards"
	turn_wait_time = 1
	
	
	cards_pointer = cards_pointer_
	wait_for_each_mark = wait_for_each_mark_
	mark_type = mark_type_
	opponent = opponent_
	

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	var cards : Array = cards_pointer.grab()
	for card : _Doomer_Card in cards:
		if wait_for_each_mark:
			await card.add_mark(mark_type, opponent,  false)
		else:
			card.add_mark(mark_type, opponent, false)
	
	# await doomer.board.mark_cards(cards, mark, wait_for_each_mark)
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
