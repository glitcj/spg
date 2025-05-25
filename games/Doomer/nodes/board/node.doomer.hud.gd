extends Node2D
class_name _Doomer_HUD

@onready var turn_indicator = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer/CenterContainer/TurnIndicatorSprite
@onready var turn_label = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer3/CenterContainer/TurnLabel

@onready var tug_of_doom_indicator = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/MarginContainer2/CenterContainer/TugIndicatorSprite
var tug_of_doom_max_position = Vector2(20, 0)
var tug_of_doom_min_position = Vector2(-20, 0)
var tug_of_doom_final_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_tug_of_doom_position()

func _update_tug_of_doom_position():
	if tug_of_doom_final_position != tug_of_doom_indicator.position:
		var diff : Vector2 = (tug_of_doom_final_position - tug_of_doom_indicator.position)
		tug_of_doom_indicator.position = tug_of_doom_indicator.position + diff/diff.abs()
