extends EventBase
class_name RemoveNodeEvent

var node_name

func initialise(node_name_) -> RemoveNodeEvent:
	node_name = node_name_
	return self

func run():
	Variables.global[node_name].queue_free()
	Variables.global.erase(node_name)
	_clean_up()

func _event_type():
	return "RemoveNodeEvent"
