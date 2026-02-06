extends Node
class_name _Doomer_Templates

static var portrait = preload("res://games/Doomer/nodes/portrait/doomer.portrait.tscn")
static var coin_box_coin = preload("res://games/Doomer/nodes/coin_box/doomer.coin_box.coin.tscn")
static var card_mark = preload("res://games/Doomer/nodes/card/doomer.card.mark.tscn")

# Recent:
var tscn_gun = "res://games/Doomer/nodes/gun/doomer.gun.tscn"
var turn_start_screen_player_input = "res://games/Doomer/nodes/turner/turns/doomer.turn.start_screen.player_input.gd"
var turn_world_map_player_input = "res://games/Doomer/nodes/turner/turns/doomer.turn.world_map.player_input.gd"

var turn_lambda = "res://games/Doomer/nodes/turner/turns/doomer.turn.lambda.gd"
var turn_turns = "res://games/Doomer/nodes/turner/turns/doomer.turns.gd"

# References:
var turn_field = "res://games/Doomer/nodes/turner/turns/doomer.turn.field.gd"
var turn_enemy = "res://games/Doomer/nodes/turner/turns/doomer.turn.enemy.gd"
var turn_player = "res://games/Doomer/nodes/turner/turns/doomer.turn.player.gd"
var tscn_portrait = "res://games/Doomer/nodes/portrait/doomer.portrait.tscn"

var turn_card_attack = "res://games/Doomer/nodes/turner/turns/doomer.turn.card_attack.gd"


# TSCN:
var tscn_doomer = "res://games/Doomer/doomer.tscn"
var tscn_doomer_pointer = "res://games/Doomer/doomer.pointer.gd"
var tscn_card = "res://games/Doomer/nodes/card/node.doomer.card.tscn"
var tscn_card_mark = "res://games/Doomer/nodes/card/doomer.card.mark.tscn"
var tscn_message_box = "res://games/Doomer/nodes/board/doomer.message_box.tscn"
var tscn_coin_box = "res://games/Doomer/nodes/coin_box/doomer.coin_box.tscn"

var prompt_todo = "res://prompts/prompt.todo.txt"
var pormpt_common = "res://prompts/prompt.common.txt"
var prompt_context = "res://prompts/prompt.context.txt"
