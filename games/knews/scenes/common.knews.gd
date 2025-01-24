extends GDScript


static func add_contestant(contestant_tag, contestant_node, contestant_position):
	Queue.queue.append(Event.make_portrait().initialise(contestant_tag, contestant_node, contestant_position))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Enter", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Idle"))
	


static func player_message(message, uuid = OS.get_unique_id(), clear_time = 0):
	var O_O_ = MessageBoxSettings.new()
	O_O_.position = Vector2(0, 120)
	O_O_.is_autoplay = false
	O_O_.is_detached = true
	Queue.add(Event.message_box().initialise([message], false, uuid, O_O_))
	
	
	
