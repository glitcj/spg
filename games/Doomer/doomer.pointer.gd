extends Node
class_name _Doomer_Pointer

# _Doomer_Parent is created only by the orchestrator _Doomer instance
@onready var doomer : _Doomer = get_parent()
enum Keys {nothing, next_field_card, last_field_card, 
player_and_enemy_cards, field_cards, player_cards, 
enemy_cards, highest_player_or_enemy_card, flop_cards,
all_cards, player_coin_box, enemy_coin_box, winner_coin_box,
winner_opponent, loser_opponent, player_portrait,
enemy_portrait}

var key : Keys

func _ready() -> void:
	pass # Replace with function body.

func _init(key_ : Keys = Keys.nothing) -> void:
	key = key_

func grab():
	assert(key is Keys)
	if key == Keys.next_field_card:
		return doomer.board.get_next_field_card()
		
	elif key == Keys.field_cards:
		return doomer.board.get_field_cards()
		
	elif key == Keys.flop_cards:
		return doomer.board.get_flop_cards()
		
	elif key == Keys.player_and_enemy_cards:
		return doomer.board.get_player_and_enemy_cards()
		
	elif key == Keys.player_cards:
		return doomer.board.get_player_cards()
		
	elif key == Keys.enemy_cards:
		return doomer.board.get_enemy_cards()
		
	elif key == Keys.all_cards:
		return doomer.board.get_all_cards()
		
	elif key == Keys.highest_player_or_enemy_card:
		return doomer.board.get_highest_player_or_enemy_card()	
		
	elif key == Keys.player_coin_box:
		print(doomer.player_coin_box)
		return doomer.player_coin_box
		
	elif key == Keys.enemy_coin_box:
		print(doomer.player_coin_box)
		return doomer.enemy_coin_box
		
	elif key == Keys.winner_coin_box:
		return doomer.logic.get_winner_coin_box()

	elif key == Keys.winner_opponent:
		return doomer.logic.calculate_winner()
		
	elif key == Keys.loser_opponent:
		return doomer.logic.calculate_loser()
		
	elif key == Keys.player_portrait:
		return doomer.player_portrait
		
	elif key == Keys.enemy_portrait:
		return doomer.enemy_portrait
		
	else:
		assert(false)

static func unpack(things : Array):
	var unpacked_things = []
	for thing in things:
		if thing is _Doomer_Pointer:
			unpacked_things.append(thing.grab())
		else:
			unpacked_things.append(thing)
	return unpacked_things


static func flatten(things : Array):
	var flattened_things = []
	for thing in things:
		# TODO:Refactor to also handle whole-depth flattening
		if thing is Array:
			flattened_things.append_array(thing)
		else:
			flattened_things.append(thing)
	return flattened_things

static func unpack_and_flatten(things : Array):
	return flatten(unpack(things))
	


func pointer_to_next_field_card():
	return doomer.make_pointer(_Doomer_Pointer.Keys.next_field_card)

func pointer_to_field_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.field_cards)

func pointer_to_flop_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.flop_cards)
	
func pointer_to_player_and_enemy_cards():
	return doomer.make_pointer(_Doomer_Pointer.Keys.player_and_enemy_cards)
