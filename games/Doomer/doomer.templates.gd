extends Node
class_name _Doomer_Templates

var prompt_todo = "res://prompts/prompt.todo.txt"
var pormpt_common = "res://prompts/prompt.common.txt"
var prompt_context = "res://prompts/prompt.context.txt"


static var portrait = preload("res://games/Doomer/nodes/portrait/doomer.portrait.tscn")
static var coin_box_coin = preload("res://games/Doomer/nodes/coin_box/doomer.coin_box.coin.tscn")
static var card_mark = preload("res://games/Doomer/nodes/card/doomer.card.mark.tscn")

# References:
var turn_field = "res://games/Doomer/nodes/turner/turns/_doomer_turn.field.gd"
var turn_enemy = "res://games/Doomer/nodes/turner/turns/_doomer_turn.enemy.gd"
var turn_player = "res://games/Doomer/nodes/turner/turns/_doomer_turn.player.gd"
var tscn_portrait = "res://games/Doomer/nodes/portrait/doomer.portrait.all.tscn"

var turn_change_coins = "res://games/Doomer/nodes/turner/turns/_doomer_turn.change_coins.gd"
var turn_flip_cards = "res://games/Doomer/nodes/turner/turns/_doomer_turn.flip_cards.gd"
var turn_randomise_cards = "res://games/Doomer/nodes/turner/turns/_doomer_turn.randomise_cards.gd"
var turn_card_attack = "res://games/Doomer/nodes/turner/turns/_doomer_turn.card_attack.gd"
var turn_show_message = "res://games/Doomer/nodes/turner/turns/_doomer_turn.show_message.gd"
var turn_mark_cards  = "res://games/Doomer/nodes/turner/turns/_doomer_turn.mark_cards.gd"
var turn_action_cards = "res://games/Doomer/nodes/turner/turns/_doomer_turn.action_cards.gd"


# TSCN:
var tscn_doomer = "res://games/Doomer/doomer.tscn"
var tscn_doomer_pointer = "res://games/Doomer/doomer.pointer.gd"
var tscn_card = "res://games/Doomer/nodes/card/node.doomer.card.tscn"
var tscn_card_mark = "res://games/Doomer/nodes/card/doomer.card.mark.tscn"
var tscn_message_box = "res://games/Doomer/nodes/board/doomer.message_box.tscn"
var tscn_coin_box = "res://games/Doomer/nodes/coin_box/doomer.coin_box.tscn"
