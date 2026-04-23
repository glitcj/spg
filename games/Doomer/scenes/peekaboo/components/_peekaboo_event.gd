extends Node2D
class_name _Peekaboo_Event


func get_peekaboo(): return find_parent("_Peekaboo") as _Peekaboo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _Peekaboo_Player
func get_lambdas(): return find_parent("_Peekaboo_Map").find_child("_Peekaboo_Lambdas") as _Peekaboo_Lambdas
func get_variables(): return _Peekaboo_Variables
func get_area(): return find_child("Area2D") as Area2D
func get_mover(): return find_child("_Peekaboo_Mover") as _Peekaboo_Mover
func get_portrait(): return find_child("_Peekaboo_Portrait")
