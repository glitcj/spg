extends Node
class_name _Peekaboo_Lambdas

@onready var doomer : _Core = find_parent("_Core")

func get_peekaboo(): return find_parent("_PeekaBoo") as _PeekaBoo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _PeekaBoo_Player
func get_camera(): return get_map().find_child("Camera2D")


func transport_player(position: Vector2i):
	var mover = get_player().find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	mover.map_position = position


func transport_camera(position: Vector2i):
	var mover = get_map().find_child("_Peekaboo_Camera").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	mover.map_position = position

func attach_camera_to_player():
	get_camera().reparent(get_player())
	
func dettach_camera_from_player():
	get_camera().reparent(get_map().find_child("Camera"))


func move_camera(delta : Vector2i):
	var mover = get_map().find_child("_Peekaboo_Camera").find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	await mover.move(delta)
