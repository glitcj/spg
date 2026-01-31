extends _Doomer_Turn
class_name _Doomer_Turn_Card_Attack

var cards_pointer : _Doomer_Pointer
# Loser pointer
var opponent_pointer : _Doomer_Pointer
var coin_amount : int
var wait_amount : float = .2

func _init(cards_pointer_ : _Doomer_Pointer, opponent_pointer_ : _Doomer_Pointer, coin_amount_ : int) -> void:
	turn_name = "ATK"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Cards_Attack"
	turn_wait_time = 1
	coin_amount = coin_amount_
	opponent_pointer = opponent_pointer_
	cards_pointer = cards_pointer_
	
func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	var opponent : _Doomer.Opponents
	opponent = opponent_pointer.grab()
	
	var coin_box : _Doomer_Coin_Box
	var enumation : _Doomer_Card.Enumation
	var attacker_portrait : _Doomer_Portrait
	var defender_portrait : _Doomer_Portrait
	
	
	if opponent == _Doomer.Opponents.Enemy:
		coin_box = doomer.make_pointer(_Doomer_Pointer.Keys.player_coin_box).grab()
		enumation = _Doomer_Card.Enumation.AttackUp
		attacker_portrait = doomer.make_pointer(_Doomer_Pointer.Keys.player_portrait).grab()
		defender_portrait = doomer.make_pointer(_Doomer_Pointer.Keys.enemy_portrait).grab()
	else:
		coin_box = doomer.make_pointer(_Doomer_Pointer.Keys.enemy_coin_box).grab()
		enumation = _Doomer_Card.Enumation.AttackDown
		attacker_portrait = doomer.make_pointer(_Doomer_Pointer.Keys.enemy_portrait).grab()
		defender_portrait = doomer.make_pointer(_Doomer_Pointer.Keys.player_portrait).grab()
		
	var cards : Array = cards_pointer.grab()
	var counter = 0
	for card : _Doomer_Card in cards:
		var is_last_attack = counter == cards.size() - 1
		
		coin_box.add_coins(coin_amount)
		
		defender_portrait.play_enumation(_Doomer_Portrait.Animations.Damage, false)
		attacker_portrait.play_enumation(_Doomer_Portrait.Animations.Attack, false)	
		await card.play_enumation(enumation, true)
		
		if is_last_attack:
			await attacker_portrait.play_enumation(_Doomer_Portrait.Animations.AttackRallyEnd, true)
		counter += 1
		
	
	defender_portrait.play_enumation(_Doomer_Portrait.Animations.Idle, false)
	attacker_portrait.play_enumation(_Doomer_Portrait.Animations.Idle, false)
	
	await CommonFunctions.waiter(self, wait_amount)
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
