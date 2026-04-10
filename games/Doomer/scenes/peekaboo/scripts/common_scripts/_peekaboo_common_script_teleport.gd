### _common_script_teleport ###
extends _Peekaboo_Script

@export var camera_position = Vector2i.ZERO as Vector2i
@export var player_position = Vector2i.ZERO as Vector2i

@export var camera_position_node : Node2D
@export var player_position_node : Node2D


@export_enum("2k3", "rmv", "rmz") var standard : String

@export var duration = 0.0

func _on_area_entered():
	get_player().reset_movement()
	
	if camera_position_node != null:
		if duration == 0.0:
			get_lambdas().transport_camera(camera_position_node.find_child("_Peekaboo_Mover").map_position)
	else:
		get_lambdas().transport_camera(camera_position)


	if player_position_node != null:
		if duration == 0.0:
			get_lambdas().transport_player(player_position_node.find_child("_Peekaboo_Mover").map_position)
	else:
		get_lambdas().transport_player(player_position)
