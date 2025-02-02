extends EventBase
class_name AddNodeEvent

# TODO: Change to AddNodeEvent
var scene_template: Resource # TODO: :Object ?
var node_to_add: Node
var initialise_parameters: Array
var uuid: String
# TODO: Add SelectableBox as a Node
# TODO: If the node overrides Scene, signal_to_wait_for should NOT be .ready
var name_of_signal_to_wait_for: String = "" # TODO: Add nullable typing

signal signal_to_wait_for

func initialise(scene_template_path_: String, initialise_parameters_: Array, uuid_: String, name_of_signal_to_wait_for_: String = "") -> AddNodeEvent:
	scene_template = load(scene_template_path_)
	uuid = uuid_
	name_of_signal_to_wait_for = name_of_signal_to_wait_for_	
	initialise_parameters = initialise_parameters_
	return self

func run():
	if scene_template is GDScript:
		node_to_add = scene_template.new()
	elif scene_template is PackedScene:
		node_to_add = scene_template.instantiate()
		node_to_add.name = uuid
		
	if node_to_add.has_method("initialise"):
		node_to_add.initialise.callv(initialise_parameters)
	node_to_add.connect(name_of_signal_to_wait_for, _on_signal_to_wait_for_emitted)
	
	# Variables.global["active_scenes"][uuid] = node_to_add
	Variables.global[uuid] = node_to_add
	get_parent().add_child(Variables.global[uuid])
	
	if not name_of_signal_to_wait_for == "":
		await signal_to_wait_for
	_clean_up()
	

func _on_signal_to_wait_for_emitted():
	signal_to_wait_for.emit()

func _event_type():
	return "AddSceneEvent"
