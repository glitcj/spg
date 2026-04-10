extends Node
class_name _Peekaboo_Lambdas

@onready var core : _Core = find_parent("_Core")

func get_peekaboo(): return find_parent("_Peekaboo") as _Peekaboo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _Peekaboo_Player
func get_camera(): return get_map().find_child("Camera2D") as Camera2D


func transport_player(position):
	assert(position is Vector2i or position is _Peekaboo_Event)
	
	if position is Vector2i:
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
	
func show_messages(messages: Array):
	
	
	var window = _Core_Templates.window.instantiate() as _Core_Window
	var container = get_peekaboo().find_child("Canvas Bottom") as CenterContainer
	container.add_child(window)
	window.scale = Vector2(5,5)
	
	window.start(messages.duplicate())
	await window.finished
	print("window finished")
	pass



func set_base_tilemap_to_rmz_standard():
	# TODO: set tile pixel size to 48 and scale to 3.333 (159.9 pixels)
	return
	
func set_base_tilemap_to_2k3_standard():
	# TODO: set tile pixel size to 16 and scale to 10 (160 pixels)
	return
	
func set_base_tilemap_to_rmv_standard():
	# TODO: set tile pixel size to 32 and scale to 5 (160 pixels)
	return
