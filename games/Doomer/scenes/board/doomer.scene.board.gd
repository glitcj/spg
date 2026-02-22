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

func _ready() -> void:
	camera = %Camera2D as Camera2D
	scene_id = _Doomer.DoomerScene.PokerBoard
	accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

func on_orchestrator_is_ready():
	for i in range(doomer.field_cards.size()):
		doomer.field_cards[i].reparent(field_card_containers[i])

func _on_scene_start():
	var _turn = _Doomer_Turn_Field.new()
	doomer.turner.turn_state_queue.insert(0, _turn)
	
	doomer.scene.poker_board.lambdas.on_scene_start_events()
	
	super()

func _on_scene_end():
	super()
