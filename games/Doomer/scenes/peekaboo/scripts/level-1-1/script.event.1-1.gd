### Event 1-1 ###
extends _RPGM_Script
var slide_duration = 1.0

func _on_viewport_start():
	await get_rpgm().get_lambdas().show_messages(["Map started.."])
	# await get_lambdas().transport_player(get_map().find_child("_player_position_1_1").find_child("_RPGM_Mover").map_position)
	# await get_lambdas().transport_camera(get_map().find_child("_camera_position_1_1").find_child("_RPGM_Mover").map_position)
	get_parent().queue_free()
