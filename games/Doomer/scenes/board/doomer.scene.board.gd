extends _Doomer_Scene
class_name _Doomer_Scene_Poker_Board


@export var player_turn :  Script
@export var field_turn :  Script

@onready var lambdas  =  %"Poker Board Lambdas" as _Doomer_Poker_Board_Events

@onready var animation_player  = $AnimationPlayer as AnimationPlayer
@onready var player_portrait_container = %"Player Head Container"
@onready var opponent_portrait_container =  %"Enemy Head Container"


@export var camera_zoom : Vector2 :
	set(v):
		camera.zoom = v
		camera_zoom = v

@onready var all_message_boxes = [
	%HUD.message_box
]


@onready var field_card_containers : Array = find_children("CenterContainer Field Card *")
@onready var enemy_traits_message_box = %"Traits Message Box" as _Doomer_Message_Box
@onready var player_hand_message_box = %"Player Hand Message Box" as _Doomer_Message_Box
@onready var winner_declaration_message_box = %"Winner Declaration" as _Doomer_Message_Box

var round_counter = 0
var number_of_rounds = 2
var field_cards : Array[_Doomer_Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = %Camera2D as Camera2D
	scene_id = _Doomer.DoomerScene.PokerBoard
	accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
	
func on_orchestrator_is_ready():
	field_cards = doomer.field_cards
	for i in range(field_cards.size()):
		field_cards[i].reparent(field_card_containers[i])
		
func flip_next_field_card():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			await card.flip_up()
			break

func all_cards_are_up():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return false
	return true

func flip_all_field_cards(state_ : _Doomer_Card.CardState):
	for i  in range(field_cards.size()):
		var card : _Doomer_Card = field_cards[i]
		var is_last_card = i == field_cards.size() - 1
		card.state = state_
		
		if state_ == _Doomer_Card.CardState.FacingUp:
			if is_last_card:
				await card.flip_up()
			else:
				card.flip_up()
		else:
			if is_last_card:
				await card.flip_down()
			else:
				card.flip_down()
				
	return true
	
func flip_cards(cards_ : Array, direction : Variant = null, wait_for_each_flip : bool = true):
	if cards_ == []:
		return
		
	for i in range(cards_.size()):
		var card : _Doomer_Card = cards_[i]
		print("aaaaa ", i, " ", cards_.size() - 1)
		if not wait_for_each_flip and i < cards_.size() - 1:
			card.flip(direction, false)
		else:
			await card.flip(direction, true)
		
func randomise_cards(cards_):
	for card : _Doomer_Card in cards_:
		card.set_random_card_value_and_suite()

func randomise_all_field_cards():
	for card : _Doomer_Card in field_cards:
		card.set_random_card_value_and_suite()
	return true




func get_player_and_opponent_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	__cards.append_array(doomer.enemy.hand)	
	return __cards
	
func get_player_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	return __cards

func get_enemy_cards():
	var __cards = []
	__cards.append_array(doomer.player.hand)
	return __cards



func get_next_field_card():
	for card : _Doomer_Card in field_cards:
		if card.state == _Doomer_Card.CardState.FacingDown:
			return card
	return null
	
func get_field_cards():
	return field_cards
	
func get_highest_player_or_enemy_card():
	return field_cards
	
func _on_scene_start():
	var _turn = _Doomer_Turn_Field.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	
	doomer.scene.poker_board.lambdas.on_scene_start_events()
	
	super()

func _on_scene_end():
	super()
