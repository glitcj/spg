extends _Doomer_Turn
class_name _Doomer_Turn_Flip_Cards

var cards_pointer : _Doomer_Pointer
var direction : Variant = null
var wait_for_each_flip : bool = false

func _init(cards_pointer_: _Doomer_Pointer, direction_ : Variant = null, wait_for_each_flip_ : bool = false) -> void:
	turn_name = "Flip"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Flip_Next_Field_Card"
	turn_wait_time = .001
	cards_pointer = cards_pointer_
	wait_for_each_flip = wait_for_each_flip_
	
	
	if direction_:
		direction = direction_

func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	# var cards : Array = _Doomer_Pointer.unpack_and_flatten(cards_and_pointers)
	var cards : Array = cards_pointer.grab() # _Doomer_Pointer # _Doomer_Pointer.unpack_and_flatten(cards_and_pointers)
	print(cards)
	await doomer.board.flip_cards(cards, direction, wait_for_each_flip)
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
