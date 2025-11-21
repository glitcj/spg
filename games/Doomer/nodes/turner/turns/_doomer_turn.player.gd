extends _Doomer_Turn
class_name _Doomer_Turn_Player

func _init() -> void:
	turn_name = "Player"
	turn_colour = Color(1,1,1)

func on_turn_start():
	doomer.handler.mode = doomer.handler.InputMode.FoldOrCall

func on_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive
