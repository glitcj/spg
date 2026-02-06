extends Node
class_name _Doomer_Turns

enum MessageType {Dialogue, Log}

@export var doomer : _Doomer

var _turn : _Doomer_Turn
var _lambda : Callable

func buzz_message_box(_message_box : _Doomer_Message_Box):
	_lambda = _message_box.play_enumation
	_turn = _Doomer_Turn_Lambda.new(_lambda, [_Doomer_Message_Box.Enumations.Buzz])
	doomer.turner.insert_turn(_turn)

func change_scene(_scene :_Doomer.DoomerScene):
	_lambda = doomer.change_scene
	_turn = _Doomer_Turn_Lambda.new(_lambda, [_scene])
	doomer.turner.insert_turn(_turn)
	
func flip_cards(_cards_getter : Callable, _direction : Variant = null, _wait_for_each_flip : bool = false):
	_lambda = func():
		var cards : Array = _cards_getter.call()
		await doomer.board.flip_cards(cards, _direction, _wait_for_each_flip)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func randomise_cards(_cards_getter : Callable):
	_lambda = func():
		var cards : Array = _cards_getter.call()
		await doomer.board.randomise_cards(cards)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func show_message(_message : String, _wait_for_message : bool = false, _message_type : MessageType = MessageType.Dialogue, _message_box_getter : Callable = Callable()):
	_lambda = func():
		var mbg = _message_box_getter
		if not mbg.is_valid():
			mbg = doomer.pointer.message_box
		var message_box : _Doomer_Message_Box = mbg.call()
		if _message_type == MessageType.Dialogue:
			await message_box.show_dialogue(_message)
		elif _message_type == MessageType.Log:
			await message_box.show_log(_message)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func demark_cards(_cards_getter : Callable, _marks_pointer : _Doomer_Card.MarkPointers, _wait_for_each_mark : bool = false):
	_lambda = func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			if _wait_for_each_mark:
				await card.remove_marks(_marks_pointer, false)
			else:
				card.remove_marks(_marks_pointer, false)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func change_coins(_coin_amount : int, _coin_box_getter : Callable):
	_lambda = func():
		var coin_box : _Doomer_Coin_Box = _coin_box_getter.call()
		await coin_box.add_coins(_coin_amount)
		await CommonFunctions.waiter(doomer, .2)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func action_cards(_cards_getter : Callable, _card_action : _Doomer_Card.CardActions, _wait_for_each_action : bool = false):
	_lambda = func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			await card.action(_card_action)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)

func mark_cards(_cards_getter : Callable, _mark_type : _Doomer_Card_Mark.MarkType, _opponent : Variant = null, _wait_for_each_mark : bool = false):
	_lambda = func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			if _wait_for_each_mark:
				await card.add_mark(_mark_type, _opponent, false)
			else:
				card.add_mark(_mark_type, _opponent, false)
	_turn = _Doomer_Turn_Lambda.new(_lambda)
	doomer.turner.insert_turn(_turn)
