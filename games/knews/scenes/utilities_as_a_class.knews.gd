extends GDScript
class_name _Knews_Utilities_2  # Utility class to manage lID, lTags, and other recurring variables

var lID: Dictionary
var lTags: Dictionary

# Constructor to initialize lID and lTags
func _init(_lID, _lTags):
	lID = _lID
	lTags = _lTags

# Function to attach monitor to animator
func lambda_attach_monitor_to_animator():
	var monitor_animator: PortraitPallet = Variables.global[lID[lTags.lMonitorAnimator]]
	var monitor: MessageBox = Variables.global[lID[lTags.lMonitor]]
	
	monitor.get_parent().remove_child(monitor)
	monitor_animator.get_node("GFX/Sprite2D").add_child(monitor)

# Function to play monitor animation
func lambda_play_monitor_animation(animation_name: String = "Exclaim"):
	var animation_player: AnimationPlayer = Variables.global[lID[lTags.lMonitorAnimator]].get_node("AnimationPlayerA")
	assert(animation_name in animation_player.get_animation_list())
	
	if false:
		animation_player.stop()
	animation_player.play(animation_name)

# Function to load and generate assets
func load_and_generate_assets(DEBUG, PRESENTER_INTRODUCTION):
	Queue.queue.append(Event.add_node().initialise("res://games/tv/loading/loading.tscn", [], "loading_screen"))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.make_portrait().initialise("loading", "res://games/tv/portraits/pallet.loading.tscn"))
	
	Queue.queue.append(Event.play_portrait_animation().initialise("loading", "Default", false))
	Queue.queue.append(Event.fade_in().initialise(true))
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,-150]}))
	
	Queue.queue.append(Event.message_box().initialise(["...Loading Vain..."]))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))
	
	if not DEBUG:
		Queue.queue.append(Event.generate_vain().initialise("'Present a quiz game show with the contestants Abraham Linkin, Socrates, and Boris Johnson. Make it funny.'", PRESENTER_INTRODUCTION))
	Queue.queue.append(Event.wait().initialise(1))

	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.queue.append(Event.remove_portrait().initialise("loading"))
	Queue.queue.append(Event.remove_node().initialise("loading_screen"))

# Function to update monitor messages
# func lambda_update_monitor_messages(monitor_message: String, uuid):
func lambda_update_monitor_messages(monitor_message: String):
	# var monitor: MessageBox = Variables.global[uuid]
	var monitor: MessageBox = Variables.global[lID[lTags.lMonitor]]
	
	monitor.display_message_immediately(monitor_message)

# Function to set up monitor
func setup_monitor():
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": false}))
	
	var _O_O = MessageBoxSettings.new()
	_O_O.is_autoplay = false
	_O_O.is_detached = true
	_O_O.position = Vector2(0, 150)
	Queue.queue.append(Event.message_box().initialise(["   "], true, lID[lTags.lMonitor], _O_O))
	
	Queue.queue.append(Event.add_node().initialise("res://games/quiz/portraits/pallet.monitor.animator.tscn", [], lID[lTags.lMonitorAnimator]))
	Queue.queue.append(Event.wait().initialise(1))
	# Queue.queue.append(Event.lambda().initialise(lambda_attach_monitor_to_animator))
	Queue.queue.append(Event.lambda().initialise(lambda_attach_monitor_to_animator, []))
	
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": true}))

# Function to display question and options
func display_question_and_options(Presenter, question_: String, options_: Array):
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.selectable_box().initialise(question_, options_))
	
	var correct_answer_events = [
		Event.play_portrait_animation().initialise(Presenter, "Happy", true),
		Event.lambda().initialise(lambda_play_monitor_animation, ["Exclaim"]),
		Event.message_box().initialise(["That's correct !"]),
		Event.play_portrait_animation().initialise(Presenter, "ResetIdleFrame", false),
	]
	var wrong_answer_events = [Event.message_box().initialise(["Aww that was a missed chance.", "Better luck next time."])]
	
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.equals, correct_answer_events))
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.not_equals, wrong_answer_events))

# Function to erase monitor message
func erase_monitor_message():
	Variables.global[lID[lTags.lMonitor]].queue_free()
	Variables.global.erase(lID[lTags.lMonitor])
