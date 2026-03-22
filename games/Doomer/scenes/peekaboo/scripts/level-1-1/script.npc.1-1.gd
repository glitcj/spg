extends _Peekaboo_Script

func _on_automatic():
	pass
	
func _on_entered_range():
	portrait.animation_player.play("talking")

func _on_exited_range():
	portrait.animation_player.play("idle")

func _on_action_within_range_trigger():
	if variables.all[variables.Keys.l1_1_enemies_count] == 2:
		await peekaboo.message_window.start(
		["NPC: You got them !", "NPC: Go to the next location.."]
		)
		parent.queue_free()
		return
		
	await peekaboo.message_window.start(
		["NPC: Hello.", "NPC: Good to see you here !"]
		)
	get_lambdas().transport_player(Vector2i(-2, 1))
