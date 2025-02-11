extends EventBase
class_name Message


var message_box: MessageBox
var message_box_settings: MessageBoxSettings
var message_box_template = preload("res://source/messages/message_box.tscn")
var messages: Array
var detached: bool

var messages_uuid: String

func initialise(messages_: Array, detached_: bool = false, messages_uuid_: String = "", message_box_settings_: MessageBoxSettings = MessageBoxSettings.new()) -> Message:
	messages = messages_
	messages_uuid = messages_uuid_
	message_box_settings = message_box_settings_
	return self

func run():
	message_box = message_box_template.instantiate()
	message_box.fill_queue(messages)

	# TODO: Add more settings
	# message_box.initialise(SceneSettings.message_box_position, null, false)
	# TODO: Move SceneSettings.message_box_position to MessageBoxSettings
	message_box.initialise(SceneSettings.message_box_position, null, false, message_box_settings)
	message_box.uuid = "%s" % [messages_uuid]
	
	# if detached:
	# TODO: Move this to MessageBox
	if message_box_settings.is_detached:
		# assert(messages_uuid != "")
		# Variables.messages[messages_uuid] = message_box
		Variables.global[messages_uuid] = message_box
		if message_box_settings.parent_uuid != "":
			Variables.global[message_box_settings.parent_uuid].add_child(Variables.global[messages_uuid])
		else:
			get_parent().add_child(Variables.global[messages_uuid])
		_clean_up()
	else:
		add_child(message_box)
		# Note: Delete message_box, but not the event node, in case JumpToLabel is called
		message_box.connect("all_messages_shown_signal", message_box.queue_free)
		# Clean up
		message_box.connect("all_messages_shown_signal", _clean_up)

func _event_type():
	return "MessageEvent"
