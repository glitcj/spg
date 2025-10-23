extends Node
class_name _Doomer_Enemy

var portrait_tscn = preload("res://games/Doomer/nodes/portrait/node.poke.face.tscn")
var card_tscn = preload("res://games/Doomer/nodes/card/node.doomer.card.tscn")

@export var _name : String = "Opponent"
@export var coins = 10
@export var hand : Array[_Doomer_Card]
@export var is_playable = false

var portrait : _Doomer_Portrait

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portrait = portrait_tscn.instantiate()
	draw_next_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func call_hand():
	portrait.animation_player.play("Happy")
	portrait.animation_player.queue("RESET")

func show_cards_in_hand():
	for card : _Doomer_Card in hand:
		await card.flip_up()
	
func fold_hand():
	pass
	
func draw_next_hand():
	hand = [card_tscn.instantiate(), card_tscn.instantiate()]
