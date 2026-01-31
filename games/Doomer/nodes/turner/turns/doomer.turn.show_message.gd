extends _Doomer_Turn
class_name _Doomer_Turn_Show_Message


enum MessageType {Dialogue, Log}

var message : String
var wait_for_message : bool
var message_box_pointer : _Doomer_Pointer
var message_type : MessageType



func _init(message_ : String = "", wait_for_message_ : bool = false, message_type_ : MessageType = MessageType.Dialogue, message_box_pointer_ = null) -> void:
	turn_name = "MSG"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Show_Message"
	turn_wait_time = .01
	show_in_turnboard = false
	
	
	message = message_
	wait_for_message = wait_for_message_
	message_box_pointer = message_box_pointer_
	message_type = message_type_
	

func on_turn_start():
	
	
	if not message_box_pointer:
		message_box_pointer = doomer.make_pointer(_Doomer_Pointer.Keys.message_box)
		
	
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	
	var message_box : _Doomer_Message_Box = message_box_pointer.grab()
	if message_type == MessageType.Dialogue:
		await message_box.show_dialogue(message)
		
	elif message_type == MessageType.Log:
		await message_box.show_log(message)
		
	doomer.turner.turner_timer.paused = false
	
	return

func on_turn_end():
	pass
