### Event 2-1 ###
extends _Peekaboo_Script

var slide_duration = 1.0


func _on_automatic():
	await peekaboo.message_window.start(["Map started.."])


func _on_frame():
	if get_variables().l2_enemies_count == 2:
		await peekaboo.message_window.start(["NPC: You got them !", "NPC: Go to the next location.."])
		get_lambdas().transport_player(get_variables().l3_entry_position)
		get_lambdas().transport_camera(get_variables().l3_entry_position)
		parent.queue_free()
