extends Node
class_name _Doomer_Turns_World_Map


@export var doomer : _Doomer
var _turn : _Doomer_Turn

func buzz_world_map_message_box(_message_box : _Doomer_Message_Box):
	_turn = _Doomer_Turn_Lambda.new(_message_box.play_enumation, [_Doomer_Message_Box.Enumations.Buzz])
	doomer.turner.insert_turn(_turn)
