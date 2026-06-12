@tool
extends Node2D
class_name _RPGM_Event



@export var is_collision = true

func get_rpgm(): return find_parent("_RPGM") as _RPGM
func get_map(): return find_parent("_RPGM_Map") as _RPGM_Map
func get_player(): return find_parent("_RPGM_Map").find_child("Player") as _RPGM_Player
func get_lambdas(): return find_parent("_RPGM_Map").find_child("_RPGM_Lambdas") as _RPGM_Lambdas
func get_variables(): return _RPGM_Variables
func get_area(): return find_child("Area2D") as Area2D
func get_mover(): return find_child("_RPGM_Mover") as _RPGM_Mover
func get_portrait(): return find_child("_RPGM_Portrait") as _RPGM_Portrait

func _ready():
	pass
