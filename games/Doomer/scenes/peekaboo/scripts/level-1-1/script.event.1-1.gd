### Event 1-1 ###
extends _Peekaboo_Script
var slide_duration = 1.0

func _on_scene_start():
	await get_peekaboo().get_lambdas().show_messages(["Map started.."])
	await get_lambdas().transport_player(get_map().find_child("_player_position_5_1").find_child("_Peekaboo_Mover").map_position)
	await get_lambdas().transport_camera(get_map().find_child("_camera_position_5_1").find_child("_Peekaboo_Mover").map_position)
	get_parent().queue_free()
