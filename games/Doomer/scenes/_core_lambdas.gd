extends Node
class_name _Core_Lambdas

@onready var doomer : _Core = find_parent("_Core")

func waiter(time: float = 1):
	var wait_timer = get_tree().create_timer(time)
	await wait_timer.timeout

func wait(_time : float = 1):
	await waiter(_time)

func change_scene(_scene : _Core_Scene):
	await doomer.change_scene(_scene)

func find_parent_by_type(node: Node, type_name: String) -> Node:
	var current = node.get_parent()
	while current:
		if current.is_class(type_name) or current.get_class() == type_name:
			return current
		current = current.get_parent()
	return null
