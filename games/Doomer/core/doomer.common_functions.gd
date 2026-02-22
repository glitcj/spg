extends Node
class_name CommonFunctions

static func get_first_input_event_keycode(event: InputEvent):
	if event is InputEventKey and event.pressed and not event.echo:
		return event.keycode  # Returns KEY_UP, KEY_DOWN, etc.
	return null

# This function is a special case where CommonFunctions needs
# to get instantiated CommonFunctions.waiter(self, time)
static func waiter(timer_parent: Node, time: float = 1):
		var wait_timer = timer_parent.get_tree().create_timer(time)
		await wait_timer.timeout

static func move_node_to_container(node : Node2D, container : CanvasItem):
	var rect = container.get_global_rect()
	node.global_position = rect.get_center() + Vector2.ZERO
