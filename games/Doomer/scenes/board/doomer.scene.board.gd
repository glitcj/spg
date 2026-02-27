extends _Doomer_Scene
class_name _Doomer_Scene_Poker_Board

@export var player_turn :  Script
@export var field_turn :  Script

@onready var getter : _Doomer_Getter_Board = $Getter
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

@onready var hud : _Doomer_HUD = find_child("HUD")
@onready var player_gun : _Doomer_Gun = find_child("Player Gun")
@onready var enemy_gun : _Doomer_Gun = find_child("Enemy Gun")
@onready var field_cards : Array = find_children("Field Card *")
@onready var player_coin_box : _Doomer_Coin_Box = find_child("Player CoinBox")
@onready var enemy_coin_box : _Doomer_Coin_Box = find_child("Enemy CoinBox")
@onready var player_portrait : _Doomer_Portrait = find_child("Player Head")
@onready var enemy_portrait : _Doomer_Portrait = find_child("Enemy Head")
@onready var enemy_cards : Array = enemy_gun.hand_cards
@onready var player_cards : Array = player_gun.hand_cards
@onready var next_field_card : _Doomer_Card

@onready var field_card_containers : Array = find_children("CenterContainer Field Card *")
@onready var enemy_traits_message_box = %"Traits Message Box" as _Doomer_Message_Box
@onready var player_hand_message_box = %"Player Hand Message Box" as _Doomer_Message_Box
@onready var winner_declaration_message_box = %"Winner Declaration" as _Doomer_Message_Box

var round_counter = 0
var number_of_rounds = 2

func _ready() -> void:
	camera = %Camera2D as Camera2D
	scene_id = _Doomer.DoomerScene.PokerBoard
	accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

func on_orchestrator_is_ready():
	for i in range(field_cards.size()):
		field_cards[i].reparent(field_card_containers[i])

func _on_scene_start():
	super()
	doomer.scene.poker_board.lambdas.on_scene_start_events()
	await _Doomer_Turn_Field.new(doomer).start()
	

func _on_scene_end():
	super()
