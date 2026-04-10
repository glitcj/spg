### Event 1-1 ###
extends _Peekaboo_Script
var slide_duration = 1.0

func _on_scene_start():
	await get_peekaboo().get_lambdas().show_messages(["Map started.."])
	await get_lambdas().transport_player(get_map().find_child("_player_position_4_2").find_child("_Peekaboo_Mover").map_position)
	await get_lambdas().transport_camera(get_map().find_child("_camera_position_4_1").find_child("_Peekaboo_Mover").map_position)


func _on_frame():
	if get_variables().l1_enemies_count == 2:
		await get_peekaboo().get_lambdas().show_messages(
			["NPC: You got them !", "NPC: Go to the next location.."],
		)
		get_lambdas().transport_player(get_variables().l2_entry_position)
		get_lambdas().transport_camera(get_variables().l2_entry_position)
		parent.queue_free()
