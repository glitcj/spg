### Event 4-1 ###
extends _Peekaboo_Script

var slide_duration = 1.0

func _on_scene_start():
	pass

func _on_frame():
	if get_variables().l3_enemies_count == 2:

		await get_peekaboo().get_lambdas().show_messages(
		["NPC: You win !"]
		)
		get_tree().quit()
		get_lambdas().transport_player(get_variables().l4_entry_position)
		get_lambdas().transport_camera(get_variables().l4_entry_position)
		parent.queue_free()
		
