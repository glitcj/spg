extends Node
class_name _Doomer_Lambdas

@export var doomer : _Doomer

func waiter(time: float = 1):
	var wait_timer = get_tree().create_timer(time)
	await wait_timer.timeout

func wait(_time : float = 1):
	await waiter(_time)

func buzz_message_box(_message_box : _Doomer_Message_Box):
	await _message_box.play_enumation(_Doomer_Message_Box.Enumations.Buzz)

func change_scene(_scene :_Doomer.DoomerScene):
	await doomer.change_scene(_scene)
