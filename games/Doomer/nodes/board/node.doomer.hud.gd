extends Node2D
class_name _Doomer_HUD

@onready var turn_indicator = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/CenterContainer/TurnIndicatorSprite
@onready var turn_label = $PanelContainer/VBoxContainer/HBoxContainer2/MarginContainer3/CenterContainer/TurnLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
