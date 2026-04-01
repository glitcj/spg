extends _Peekaboo_Script

func _on_scene_start():
	pass
	


func _on_entered_range():
	portrait.animation_player.play("talking")

func _on_exited_range():
	portrait.animation_player.play("idle")

func _on_action_within_range_trigger():

	await peekaboo.message_window.start(
		["NPC: Hello.", "NPC: Good to see you here !"]
		)
