extends GDScript

# TODO: Change this to a class _Knews_Utilities/_Knews_Common_Events, loading lID, lTags and any other recurring vars

# static func lambda_attach_monitor_to_animator(uuid):
static func lambda_attach_monitor_to_animator(lID, lTags):
	# var monitor_animator: PortraitPallet = Variables.global["active_scenes"]["monitor_animator"]
	# var monitor: MessageBox = Variables.messages[lID[lTags.lMonitorAnimator]]
	var monitor_animator: PortraitPallet = Variables.global[lID[lTags.lMonitorAnimator]]
	# var monitor: MessageBox = Variables.messages[lID[lTags.lMonitor]]
	var monitor: MessageBox = Variables.global[lID[lTags.lMonitor]]
	
	monitor.get_parent().remove_child(monitor)
	monitor_animator.get_node("GFX/Sprite2D").add_child(monitor)
	
static func lambda_play_monitor_animation(lID, lTags, animation_name: String = "Exclaim"):
	# TODO: Replace with signal sent to animator node
	# TODO: Replace with enumed UUIDs
	# var animation_player = Variables.global[lID[lTags.lMonitorAnimator]].get_node("AnimationPlayerA").play(animation_name)
	var animation_player: AnimationPlayer = Variables.global[lID[lTags.lMonitorAnimator]].get_node("AnimationPlayerA")
	animation_player.play(animation_name)

	# TODO: This is probably not safe, double check threads/cycles
	Queue.insert(Event.wait().initialise(5))

# TODO: Add background looping audience ambience
static func load_and_generate_assets(DEBUG, PRESENTER_INTRODUCTION):
	Queue.queue.append(Event.add_node().initialise("res://games/tv/loading/loading.tscn", [], "loading_screen"))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.make_portrait().initialise("loading", "res://games/tv/portraits/pallet.loading.tscn"))
	
	
	# TODO: Replace animation enums with strings
	Queue.queue.append(Event.play_portrait_animation().initialise("loading", "Default", false))
	Queue.queue.append(Event.fade_in().initialise(true))
	
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,-150]}))
	
	Queue.queue.append(Event.message_box().initialise(["...Loading Vain..."]))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))
	
	# Generate buffers
	if not DEBUG:
		Queue.queue.append(Event.generate_vain().initialise("'Present a quiz game show with the contestants Abraham Linkin, Socrates, and Boris Johnson. Make it funny.'", PRESENTER_INTRODUCTION))
	Queue.queue.append(Event.wait().initialise(1))

	# Transition
	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.queue.append(Event.remove_portrait().initialise("loading"))
	Queue.queue.append(Event.remove_node().initialise("loading_screen"))


static func lambda_update_monitor_messages(monitor_message: String, uuid):
	var monitor: MessageBox = Variables.global[uuid]
	monitor.display_message_immediately(monitor_message)
	
static func setup_monitor(lTags, lID):
	# WIP
	
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": false}))
	
	var _O_O = MessageBoxSettings.new()
	_O_O.is_autoplay = false
	_O_O.is_detached = true
	_O_O.position = Vector2(0, 150)
	Queue.queue.append(Event.message_box().initialise(["   "], true, lID[lTags.lMonitor], _O_O))
	
	# Queue.queue.append(Event.add_node().initialise("res://games/quiz/portraits/pallet.monitor.animator.tscn", [], "monitor_animator_%s" % lID))
	Queue.queue.append(Event.add_node().initialise("res://games/quiz/portraits/pallet.monitor.animator.tscn", [], lID[lTags.lMonitorAnimator]))
	Queue.queue.append(Event.wait().initialise(1))
	if false:
		Queue.queue.append(Event.message_box().initialise(["Attaching Monitor"]))
	
	# TODO
	Queue.queue.append(Event.lambda().initialise(lambda_attach_monitor_to_animator, [lID, lTags]))
	
	Queue.queue.append(Event.lambda().initialise(lambda_play_monitor_animation, [lID, lTags, "RESET"]))
	
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": true}))
	
	
static func display_question_and_options(Presenter, question_: String, options_: Array, lTags, lID):
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.selectable_box().initialise(question_, options_))
	
	var correct_answer_events = [
		Event.play_portrait_animation().initialise(Presenter, "Happy", true),
		Event.lambda().initialise(lambda_play_monitor_animation, [lID, lTags, "Exclaim"]),
		Event.message_box().initialise(["That's correct !"]),
		Event.play_portrait_animation().initialise(Presenter, "ResetIdleFrame", false),
		]
	var wrong_answer_events = [Event.message_box().initialise(["Aww that was a missed chance.", "Better luck next time."])]
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.equals, correct_answer_events))
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.not_equals, wrong_answer_events))

	var erase_monitor_message = func(a):
		
		
		Variables.global[lID[lTags.lMonitor]].queue_free()
		Variables.global.erase(lID[lTags.lMonitor])
		
		# Variables.messages[uuid].queue_free()
		# Variables.messages.erase(uuid)
	Queue.queue.append(Event.lambda().initialise(erase_monitor_message, []))
