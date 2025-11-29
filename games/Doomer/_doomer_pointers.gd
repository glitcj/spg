extends Node
class_name _Doomer_Pointer

# _Doomer_Parent is created only by the orchestrator _Doomer instance
@onready var doomer : _Doomer = get_parent()
enum Keys {nothing, next_field_card, last_field_card, 
player_and_opponent_cards, field_cards, player_cards, 
enemy_cards, highest_player_or_enemy_card}

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
		
	elif key == Keys.player_and_opponent_cards:
		return doomer.board.get_player_and_opponent_cards()
		
	elif key == Keys.player_cards:
		return doomer.board.get_player_cards()
		
	elif key == Keys.enemy_cards:
		return doomer.board.get_enemy_cards()
		
				
	elif key == Keys.highest_player_or_enemy_card:
		return doomer.get_highest_player_or_enemy_card()	
		
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
	
