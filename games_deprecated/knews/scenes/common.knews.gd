extends GDScript

var lID: Dictionary = _Knews_Constants.lID
var lTags: Dictionary = _Knews_Constants.lTags




static func player_message(message, uuid = Variables.generate_uuid(), clear_time = 0):
	var O_O_ = MessageBoxSettings.new()
	O_O_.position = Vector2(0, 180)
	O_O_.is_autoplay = true
	O_O_.is_detached = true
	O_O_.autoplay_wait_seconds = 2
	Queue.add(Event.message_box().initialise([message], false, uuid, O_O_))
	
	if true:
		Queue.queue.append(Event.wait().initialise(0.05))
		Queue.add(Event.lambda().initialise(wait_for_message_to_clear, [uuid]))





# TODO: If an event accesses Variables.global it is a lambda
func stage_message(messages):
	# print(_Knews_Constants.stage_message_box_settings.parent_uuid)
	
	# var O_O_ = _Knews_Constants.stage_message_box_settings
	# O_O_.parent = Variables.global[lID[lTags.Stage]].get_node("ViewportsControl/SubViewportContainerStage/SubViewport/Stage")
	# Queue.add(Event.message_box().initialise(messages, false, uuid, _Knews_Constants.stage_message_box_settings))
	"""
	if true:
		Queue.queue.append(Event.wait().initialise(0.05))
		Queue.add(Event.lambda().initialise(wait_for_message_to_clear, [uuid]))
	"""


	Queue.queue.append(Event.lambda().initialise(lambda_stage_message, [messages]))



# TODO: If an event accesses Variables.global it is a lambda
func lambda_stage_message(messages, uuid = Variables.generate_uuid(), clear_time = 0):
	# print(_Knews_Constants.stage_message_box_settings.parent_uuid)
	
	# var O_O_ = _Knews_Constants.stage_message_box_settings
	# O_O_.parent = Variables.global[lID[lTags.Stage]].get_node("ViewportsControl/SubViewportContainerStage/SubViewport/Stage")
	_Knews_Constants.stage_message_box_settings.parent = Variables.global[lID[lTags.Stage]].get_node("ViewportsControl/SubViewportContainerStage/SubViewport/Stage")
	
	# Queue.add(Event.message_box().initialise(messages, false, uuid, _Knews_Constants.stage_message_box_settings))
	Queue.insert(Event.message_box().initialise(messages, false, uuid, _Knews_Constants.stage_message_box_settings))
	"""
	if true:
		Queue.queue.append(Event.wait().initialise(0.05))
		Queue.add(Event.lambda().initialise(wait_for_message_to_clear, [uuid]))
	"""



static func wait_for_message_to_clear(uuid):
	var _O_O: MessageBox = Variables.global[uuid]
	await Queue.occupy_global_queue(_O_O.all_messages_shown_signal)
	
static func lambda_debug_break():
	var O_O_ = 0
	O_O_ = 0
