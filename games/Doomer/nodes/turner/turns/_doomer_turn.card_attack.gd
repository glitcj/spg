extends _Doomer_Turn
class_name _Doomer_Turn_Card_Attack

var coin_amount : int
var coin_box_pointer : _Doomer_Pointer
var wait_amount : float = .2

func _init(coin_amount_: int, coin_box_pointer_ : _Doomer_Pointer) -> void:
	turn_name = "Flip"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Coins"
	turn_wait_time = 1
	coin_amount = coin_amount_
	coin_box_pointer = coin_box_pointer_
	
func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	# var coin_box : _Doomer_Coin_Box = _Doomer_Pointer.unpack_and_flatten([coin_box_pointer])
	var coin_boxes : Array = _Doomer_Pointer.unpack([coin_box_pointer])
	for coin_box : _Doomer_Coin_Box in coin_boxes:
		await coin_box.add_coins(coin_amount)
		await CommonFunctions.waiter(self, wait_amount)
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
