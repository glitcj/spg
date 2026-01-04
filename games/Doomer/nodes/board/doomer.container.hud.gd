extends Node2D
class_name _Doomer_HUD

# @export var doomer : _Doomer
@onready var turn_indicator = $HBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/MarginContainer4/CenterContainer/TurnIndicatorSprite
@onready var tug_of_doom_indicator = $HBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/MarginContainer2/CenterContainer/TugIndicatorSprite
# @onready var hourglass : Node2D = $HBoxContainer/VBoxContainer/MarginContainer2/CenterContainer/Hourglass
@onready var hourglass : Node2D = $Hourglass

@onready var turn_label = $HBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer3/CenterContainer/Panel/MarginContainer/TurnLabel
@onready var turnboard : _Doomer_Portrait = $HBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer3/CenterContainer/Portrait
@onready var game_log : Node2D = $HBoxContainer/PanelContainer/HBoxContainer/MarginContainer/LogAndDialogue

@onready var message_box : _Doomer_Message_Box = $HBoxContainer/MarginContainer/MessageBox

var tug_of_doom_max_position = Vector2(20, 0)
var tug_of_doom_min_position = Vector2(-20, 0)
var tug_of_doom_final_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# _update_tug_of_doom_position()
	pass
