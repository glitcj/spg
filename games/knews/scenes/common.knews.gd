extends GDScript


static func add_contestant(contestant_tag, contestant_node, contestant_position):
	Queue.queue.append(Event.make_portrait().initialise(contestant_tag, contestant_node, contestant_position))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Enter", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Idle"))
	
static func player_message(message, uuid = Variables.generate_uuid(), clear_time = 0):
	var O_O_ = MessageBoxSettings.new()
	O_O_.position = Vector2(0, 180)
	O_O_.is_autoplay = true
	O_O_.is_detached = true
	O_O_.autoplay_wait_seconds = 2
	Queue.add(Event.message_box().initialise([message], false, uuid, O_O_))
	
	if true:
		Queue.add(Event.lambda().initialise(wait_for_message_to_clear, [uuid]))
	
	
static func wait_for_message_to_clear(uuid):
	var _O_O: MessageBox = Variables.global[uuid]
	await _O_O.all_messages_shown_signal
	
static func lambda_debug_break():
	var O_O_ = 0
	O_O_ = 0
