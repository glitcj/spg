extends Node
class_name _Doomer_Handler

@onready var doomer: _Doomer = get_parent()

enum Action {Call, Check, Fold}

var InputToAction := {
	"ui_up": Action.Call,
	"ui_down": Action.Fold,
	"ui_right": Action.Check	
}

enum InputMode {Inactive, FoldOrCall}
signal finished_input_mode

var mode: InputMode = InputMode.Inactive
var tray = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_inputs(event):
	if mode == InputMode.Inactive:
		return
	elif mode == InputMode.FoldOrCall:
		_handle_betting_action(event)

func get_from_input_mode(mode_):
	mode = mode_


func _handle_betting_action(event):
	var event_name = CommonFunctions.get_first_input_event_name(event)
	if event_name not in InputToAction.keys():
		return
	if InputToAction[event_name] == Action.Call:
		_on_call_action()
	if InputToAction[event_name] == Action.Fold:
		_on_fold_action()
	finished_input_mode.emit()

func _on_call_action():
	doomer.player.call_hand()
	doomer.turner._update_turn_state()
	pass
	

func _on_fold_action():
	doomer.player.call_hand()
	# doomer.turner._update_turn_state()
	pass


func _reset():
	tray = null
	mode = InputMode.Inactive
