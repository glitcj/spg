extends Node
class_name _Doomer_Actions

@onready var doomer: _Doomer = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func opponent_calls():
	doomer.board.opponent_portrait.animation_player.play("Happy")
	doomer.board.opponent_portrait.animation_player.queue("RESET")
