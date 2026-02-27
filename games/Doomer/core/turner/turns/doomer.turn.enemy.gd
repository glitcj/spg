extends _Doomer_Turn
class_name _Doomer_Turn_Enemy

static var accepted_inputs = []

enum Action {Call, Fold}
var action : Action

func _init(_doomer: _Doomer) -> void:
	super(_doomer)
	turn_name = "ENM"
	turn_colour = Color(1,1,1)
	turn_wait_time = _Doomer_Constants.immediate_action_time_delta

func on_turn_start():
	await doomer.lambdas.waiter(turn_wait_time/2)
	action = Action.values()[randi() % Action.size()]
	await _process_action()
	on_turn_end()

func on_turn_end():
	doomer.handler.mode = doomer.handler.InputMode.Inactive
	super()

func _process_action():
	if action == Action.Call:
		await _on_call_action()
	if action == Action.Fold:
		await _on_fold_action()



func _on_call_action():
	var _portrait : _Doomer_Portrait = doomer.scene.poker_board.getter.enemy_portrait()
	_portrait.play_enumation_queue([_Doomer_Portrait.Animations.Attack, _Doomer_Portrait.Animations.RESET, _Doomer_Portrait.Animations.Idle], false)

	var cards = doomer.scene.poker_board.getter.cards_ready_to_bet_by_enemy()
	var mark_type = _Doomer_Card_Mark.MarkType.ATK

	for card : _Doomer_Card in cards:
		card.add_mark(mark_type, _Doomer.Opponents.Enemy)

func _on_fold_action():
	var _portrait : _Doomer_Portrait = doomer.scene.poker_board.getter.enemy_portrait()
	_portrait.play_enumation_queue([_Doomer_Portrait.Animations.Damage, _Doomer_Portrait.Animations.RESET,  _Doomer_Portrait.Animations.Idle], false)

	var cards = doomer.scene.poker_board.getter.cards_ready_to_bet_by_enemy()
	var mark_type = _Doomer_Card_Mark.MarkType.DEF

	for card : _Doomer_Card in cards:
		card.add_mark(mark_type, _Doomer.Opponents.Enemy)
