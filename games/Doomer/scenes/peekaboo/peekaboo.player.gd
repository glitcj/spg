extends Node2D
class_name _PeekaBoo_Player


@export var peekaboo : _PeekaBoo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	_on_input()
	
func _on_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	peekaboo.player.move_and_collide(direction * peekaboo.player_speed)
	peekaboo.lambdas.update_idle_animation()


func _on_input_move_and_slide_player():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	peekaboo.player.velocity = direction * peekaboo.player_speed
	peekaboo.player.move_and_collide(direction * peekaboo.player_speed)
