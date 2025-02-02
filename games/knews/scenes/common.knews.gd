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
	


static func lambda_debug_break():
	var O_O_ = 0
	O_O_ = 0
