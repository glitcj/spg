extends Node
class_name _Doomer_Lambdas


enum MessageType {Dialogue, Log}

@export var doomer : _Doomer

func wait(_time : float = 1) -> Callable:
	return func():
		await CommonFunctions.waiter(doomer, _time)

func buzz_message_box(_message_box : _Doomer_Message_Box) -> Callable:
	return func():
		await _message_box.play_enumation(_Doomer_Message_Box.Enumations.Buzz)

func change_scene(_scene :_Doomer.DoomerScene) -> Callable:
	return func():
		doomer.change_scene(_scene)

func flip_cards(_cards_getter : Callable, _direction : Variant = null, _wait_for_each_flip : bool = false) -> Callable:
	return func():
		var cards : Array = _cards_getter.call()
		await doomer.board.flip_cards(cards, _direction, _wait_for_each_flip)

func randomise_cards(_cards_getter : Callable) -> Callable:
	return func():
		var cards : Array = _cards_getter.call()
		await doomer.board.randomise_cards(cards)

func show_message(_message : String, _wait_for_message : bool = false, _message_type : MessageType = MessageType.Dialogue, _message_box_getter : Callable = Callable()) -> Callable:
	return func():
		var mbg = _message_box_getter
		if not mbg.is_valid():
			mbg = doomer.pointer.message_box
		var message_box : _Doomer_Message_Box = mbg.call()
		if _message_type == MessageType.Dialogue:
			await message_box.show_dialogue(_message)
		elif _message_type == MessageType.Log:
			await message_box.show_log(_message)

func demark_cards(_cards_getter : Callable, _marks_pointer : _Doomer_Card.MarkPointers, _wait_for_each_mark : bool = false) -> Callable:
	return func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			if _wait_for_each_mark:
				await card.remove_marks(_marks_pointer, false)
			else:
				card.remove_marks(_marks_pointer, false)

func change_coins(_coin_amount : int, _coin_box_getter : Callable) -> Callable:
	return func():
		var coin_box : _Doomer_Coin_Box = _coin_box_getter.call()
		await coin_box.add_coins(_coin_amount)
		await CommonFunctions.waiter(doomer, .2)

func action_cards(_cards_getter : Callable, _card_action : _Doomer_Card.CardActions, _wait_for_each_action : bool = false) -> Callable:
	return func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			await card.action(_card_action)

func mark_cards(_cards_getter : Callable, _mark_type : _Doomer_Card_Mark.MarkType, _opponent : Variant = null, _wait_for_each_mark : bool = false) -> Callable:
	return func():
		var cards : Array = _cards_getter.call()
		for card : _Doomer_Card in cards:
			if _wait_for_each_mark:
				await card.add_mark(_mark_type, _opponent, false)
			else:
				card.add_mark(_mark_type, _opponent, false)

func card_attack(_cards_getter : Callable, _loser_getter : Callable, _coin_amount : int) -> Callable:
	return func():
		var opponent : _Doomer.Opponents = _loser_getter.call()

		var coin_box : _Doomer_Coin_Box
		var enumation : _Doomer_Card.Enumation
		var attacker_portrait : _Doomer_Portrait
		var defender_portrait : _Doomer_Portrait

		if opponent == _Doomer.Opponents.Enemy:
			coin_box = doomer.pointer.player_coin_box()
			enumation = _Doomer_Card.Enumation.AttackUp
			attacker_portrait = doomer.pointer.player_portrait()
			defender_portrait = doomer.pointer.enemy_portrait()
		else:
			coin_box = doomer.pointer.enemy_coin_box()
			enumation = _Doomer_Card.Enumation.AttackDown
			attacker_portrait = doomer.pointer.enemy_portrait()
			defender_portrait = doomer.pointer.player_portrait()

		var cards : Array = _cards_getter.call()
		var counter = 0
		for card : _Doomer_Card in cards:
			var is_last_attack = counter == cards.size() - 1
			coin_box.add_coins(_coin_amount)

			defender_portrait.play_enumation(_Doomer_Portrait.Animations.Damage, false)
			attacker_portrait.play_enumation(_Doomer_Portrait.Animations.Attack, false)
			await card.play_enumation(enumation, true)

			if is_last_attack:
				await attacker_portrait.play_enumation(_Doomer_Portrait.Animations.AttackRallyEnd, true)
			counter += 1

		defender_portrait.play_enumation(_Doomer_Portrait.Animations.Idle, false)
		attacker_portrait.play_enumation(_Doomer_Portrait.Animations.Idle, false)

		await CommonFunctions.waiter(doomer, .2)
