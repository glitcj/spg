extends _Peekaboo_Script

# var is_running = false

func _on_entered_range():
	portrait.animation_player.play("talking")


func _on_exited_range():
	portrait.animation_player.play("idle")


func _on_action_within_range_trigger():
	# if is_running:
	# 	return
	# is_running = true
	await peekaboo.message_window.start(
		["NPC: Hello.", "NPC: Good to see you here !", "Another one"]
		)
	# is_running = false
