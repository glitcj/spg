extends _Peekaboo_Script

func _on_automatic():
	portrait.animation_player.play("idle")
	
func _on_entered_range():
	portrait.animation_player.play("talking")

func _on_exited_range():
	portrait.animation_player.play("idle")

func _on_action_within_range_trigger():
	await peekaboo.message_window.start(
	["Some enemies can only be seen by light.", "You can sense them, they bugs show in their wake."]
	)
	parent.queue_free()
	return
	
