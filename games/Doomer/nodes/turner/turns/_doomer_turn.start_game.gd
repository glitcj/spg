extends _Doomer_Turn
class_name _Doomer_Turn_Start_Game

func _init() -> void:
	turn_name = "StartGame"
	turn_colour = Color(1,1,1)

func on_turn_start():

	doomer.board.randomise_all_field_cards()
	doomer.player.randomise_hand()
	doomer.enemy.randomise_hand()
	
	for opponent in doomer.opponents:
		opponent.show_cards_in_hand()	
	
	doomer.turner.turn_state_queue.insert(0, _Doomer_Turn_Field.new())

func on_turn_end():
	pass
