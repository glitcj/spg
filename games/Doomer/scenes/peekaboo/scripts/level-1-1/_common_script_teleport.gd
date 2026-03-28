### _common_script_teleport ###
extends _Peekaboo_Script

@export var camera_position = Vector2i.ZERO as Vector2i
@export var player_position = Vector2i.ZERO as Vector2i

@export var use_position_name = false

@export var camera_position_name = "" as String
@export var player_position_name = "" as String

@export var duration = 0.0

func _on_area_entered():
	get_player().reset_movement()
	
	
	if not use_position_name:
		if duration == 0.0:
			get_lambdas().transport_camera(camera_position)
			get_lambdas().transport_player(player_position)


	if use_position_name and camera_position != "":
		var camera_position_node = get_map().find_child(camera_position)
		assert(camera_position_node != null)
		if duration == 0.0:
			get_lambdas().transport_camera(camera_position_node.find_child("_Peekaboo_Mover").map_position)

	if use_position_name and player_position != "":
		var player_position_node = get_map().find_child(player_position)
		assert(player_position_node != null)
		if duration == 0.0:
			get_lambdas().transport_player(player_position_node.find_child("_Peekaboo_Mover").map_position)


	
