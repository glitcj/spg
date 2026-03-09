extends Node2D
class_name _PeekaBoo_Player


@export var peekaboo : _PeekaBoo
var is_active = true


var direction = Vector2.ZERO as Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_active = true	
	print(peekaboo.scripts_currently_on_map())
	for script : _Peekaboo_Script in peekaboo.scripts_currently_on_map():
		print(script.is_running(), script.interrupt_player)
		if script.is_running() and script.interrupt_player:
			is_active = false
	pass


func _physics_process(delta: float) -> void:
	if not is_active:
		return
		
	_on_input()
	_update_movement()
	
func _valid_direction_is_pressed():
	
	for d in ["ui_up", "ui_down", "ui_left", "ui_right"]:
		if Input.is_action_just_pressed(d):
			return true
	return false
	
func _on_input():
	if _valid_direction_is_pressed():
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# else:
	# 	direction = Vector2.ZERO
	
	
	if Input.is_action_just_pressed("ui_accept"):
		direction = Vector2.ZERO
	# peekaboo.map.player.move_and_collide(direction * peekaboo.player_speed)
	# peekaboo.lambdas.update_idle_animation()


func _update_movement():
	if direction == Vector2.ZERO:
		return
	peekaboo.map.player.move_and_collide(direction * peekaboo.player_speed)
	peekaboo.lambdas.update_idle_animation()


"""
func _on_input_move_and_slide_player():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	peekaboo.player.velocity = direction * peekaboo.player_speed
	peekaboo.player.move_and_collide(direction * peekaboo.player_speed)
"""
