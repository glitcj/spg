extends _Peekaboo_Script

@export var messages = []

func _on_scene_start():
	pass
	
func _on_entered_range():
	portrait.animation_player.play("talking")

func _on_exited_range():
	portrait.animation_player.play("idle")

func _on_action_within_range_trigger():
	await get_mover().face(_get_direction_to_player())
	await peekaboo.message_window.start(messages)
