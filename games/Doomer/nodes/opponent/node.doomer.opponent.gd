extends Node
class_name _Doomer_Opponent


var portrait_template = preload("res://games/Doomer/nodes/portrait/node.poke.face.tscn")

@export var _name : String = "Opponent"
@export var coins = 10
@export var is_playable = false

var portrait : _Doomer_Portrait


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portrait = portrait_template.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func call_hand():
	
	portrait.animation_player.play("Happy")
	portrait.animation_player.queue("RESET")
	
	
func fold_hand():
	pass
