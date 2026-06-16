@tool
extends Node2D
class_name _RPGM_Event

var is_collision = true

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

func _child_entered_tree(_node: Node) -> void:
	notify_property_list_changed()

func _child_exiting_tree(_node: Node) -> void:
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	if not is_inside_tree(): return []
	var props: Array[Dictionary] = []
	if get_mover():
		props.append({
			"name": "_RPGM_Mover",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_CATEGORY
		})
		props.append({
			"name": "is_collision",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return props

func _get(property: StringName) -> Variant:
	if property == "is_collision": return is_collision
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "is_collision":
		is_collision = value
		return true
	return false
