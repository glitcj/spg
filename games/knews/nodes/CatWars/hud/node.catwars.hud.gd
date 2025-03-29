extends Node
class_name _Mushmash_HUD

@onready var turn_label := $Turn/PanelContainer/VBoxContainer/TurnLabel
@onready var hp_label := $Status/PanelContainer/VBoxContainer/HPLabel
@onready var mission_label := $Mission/PanelContainer/VBoxContainer/MissionLabel
@onready var turn_indicator := $TurnIndicatorSprite
@onready var mushmash: _MushMash = get_parent().get_parent()

var log := ["This is a sample.", "This is a sample.", "This is a sample.", "This is a sample."]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_status_hud()
	_update_action_log()
	
func _update_action_log():
	var log_text = ""
	for i in len(log):
		if i > 3:
			break
		log_text = log_text + "  " + log[i] + "\n"
	$"Log/PanelContainer/VBoxContainer/Label".text = log_text

func _update_status_hud():
	hp_label.text = "HP: %s" % mushmash.player.damager.health
