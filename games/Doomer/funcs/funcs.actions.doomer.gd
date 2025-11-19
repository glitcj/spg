extends Node
class_name _Doomer_Actions

@onready var doomer: _Doomer = get_parent()

func opponent_calls():
	doomer.board.opponent_portrait.animation_player.play("Happy")
	doomer.board.opponent_portrait.animation_player.queue("RESET")
