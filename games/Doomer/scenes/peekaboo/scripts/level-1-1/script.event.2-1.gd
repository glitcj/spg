### Event 2-1 ###
extends _Peekaboo_Script

var slide_duration = 1.0


func _on_scene_start():
	pass


func _on_frame():
	if get_variables().l2_enemies_count == 2:
		await get_peekaboo().get_lambdas().show_messages(["NPC: You got them !", "NPC: Go to the next location.."])
		
		# get_peekaboo().find_child()
		# get_map().find_child("_player_position_4_1")
		# get_map().find_child("_camera_position_4_1")
		# get_lambdas().transport_player(get_variables().l3_entry_position)
		# get_lambdas().transport_camera(get_variables().l3_entry_position)
		get_lambdas().transport_player(get_map().find_child("_player_position_4_1"))
		get_lambdas().transport_camera(get_map().find_child("_camera_position_4_1"))
		parent.queue_free()
