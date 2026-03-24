extends _Peekaboo_Script

var slide_duration = 1.0

func _on_automatic():
	await peekaboo.message_window.start(["Map started.."])
	await get_lambdas().move_camera(Vector2i(0, -5))
	await peekaboo.message_window.start(["1", "2", "3"])
	await get_lambdas().move_camera(Vector2i(0, 1))
	

func _on_frame():
	if get_variables().l1_1_enemies_count == 2:

		await peekaboo.message_window.start(
		["NPC: You got them !", "NPC: Go to the next location.."]
		)
		get_lambdas().transport_player(get_variables().l3_1_entry_position)
		get_lambdas().transport_camera(get_variables().l3_1_entry_position)
		parent.queue_free()
