### _teleport 4-1 ###
extends _Peekaboo_Script

var slide_duration = 1.0

func _on_area_entered():
	get_player().reset_movement()
	
	get_lambdas().transport_player(get_variables().l1_entry_position)
	get_lambdas().transport_camera(get_map().find_child("_camera_position_l1_1").find_child("_Peekaboo_Mover").map_position)
