### Event 1-1 ###
extends _Peekaboo_Script

var slide_duration = 1.0

func _on_automatic():
	await peekaboo.message_window.start(["Map started.."])
	# await get_lambdas().move_camera(Vector2i(0, -4))
	await get_lambdas().transport_player(get_variables().l4_entry_position)
	await get_lambdas().transport_camera(get_variables().l4_camera_position)
	await get_lambdas().transport_camera(get_map().find_child("Camera Position 4-1").find_child("_Peekaboo_Mover").map_position)

func _on_frame():
	if get_variables().l1_enemies_count == 2:

		await peekaboo.message_window.start(
		["NPC: You got them !", "NPC: Go to the next location.."]
		)
		get_lambdas().transport_player(get_variables().l2_entry_position)
		get_lambdas().transport_camera(get_variables().l2_entry_position)
		parent.queue_free()
