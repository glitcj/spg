@tool
extends _Core_Scene
class_name _Peekaboo

func get_map(): return find_child("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_child("_Peekaboo_Map").find_child("Player") as _Peekaboo_Player
func get_camera(): return get_map().find_child("Camera2D") as Camera2D
func get_lambdas(): return find_child("_Peekaboo_Lambdas") as _Peekaboo_Lambdas

func _ready() -> void:
	pass


func _on_scene_start():
	super()

func _on_scene_end():
	super()

func _on_scene_activated():
	find_child("Player").is_active = true

func _on_scene_deactivated():
	find_child("Player").is_active = false
