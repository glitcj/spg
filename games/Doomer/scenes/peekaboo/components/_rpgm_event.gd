extends Node2D
class_name _RPGM_Event


var current_script : _RPGM_Script

var deprecated = false

func is_collision():
	if get_active_script():
		return get_active_script().is
	if current_script and current_script.is_collision:
		return true
	return false

func fis_collision():
	for child : _RPGM_Script in find_children("*", "_RPGM_Script"):
		if child.is_collision: return true
	return false

func get_rpgm(): return find_parent("_RPGM") as _RPGM
func get_map(): return find_parent("_RPGM_Map") as _RPGM_Map
func get_player(): return find_parent("_RPGM_Map").find_child("Player") as _RPGM_Player
func get_lambdas(): return find_parent("_RPGM_Map").find_child("_RPGM_Lambdas") as _RPGM_Lambdas
func get_variables(): return _RPGM_Variables
func get_area(): return find_child("Area2D") as Area2D
func get_mover(): return find_child("_RPGM_Mover") as _RPGM_Mover
func get_portrait(): return find_child("_RPGM_Portrait") as _RPGM_Portrait

func _ready(): pass


func _process(delta: float):
	_update_active_script()

var active_script : _RPGM_Script
func _update_active_script():
	if active_script and active_script._is_active():
		return
	if active_script and not active_script._is_active():
		active_script._on_deactivated()
		
	active_script = get_active_script()
	
	if active_script:
		active_script._on_activated()


func get_active_script():
	for script : _RPGM_Script in find_children("*", "_RPGM_Script"):
		if script._is_active():
			return script
	return null
	



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
			"name": "deprecated",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return props

func _get(property: StringName) -> Variant:
	if property == "deprecated": return deprecated
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "deprecated":
		deprecated = value
		return true
	return false
