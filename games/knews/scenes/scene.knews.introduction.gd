extends EventQueue


var common_events_1 = preload("res://games/knews/scenes/common.knews.gd")
var _constants: _Knews_Common_Variables = _Knews_Common_Variables.new()
var utilities: _Knews_Common_Events_1 = _Knews_Common_Events_1.new(_constants.lID, _constants.lTags)


func add_contestant_portraits():
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_add_contestant, [_constants.lCharacters.Presenter, _constants.lPortraits[_constants.lCharacters.Presenter], _constants.lPositions[_constants.lCharacters.Presenter]]))
	Queue.queue.append(Event.message_box().initialise(["Ladies and gentlemen.{newline}{newline}{newline}               {image,res://assets/images/default.png}", "Welcome to the Knews.", "Let's welcome our guest{newline}to the stage."]))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_add_contestant, [_constants.lCharacters.A, _constants.lPortraits[_constants.lCharacters.A], _constants.lPositions[_constants.lCharacters.A]]))
	
func contestant_introductions():
	# Contestant A
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.Presenter, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Our guest today is{newline}Alexander Bones.", "Introduce yourself !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.Presenter, "Idle", false))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Globalists are taking over.", "But.."]))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["We will NOT, FALTER !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.A, "Laugh", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.A, "Idle", false))
	Queue.queue.append(Event.wait().initialise(2))


func present_next_question(question: String, answers: Array, autoplay: bool = true):
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.message_box().initialise(["And the next question is.."]))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_play_monitor_animation, ["Enter"]))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.wait().initialise(0.5))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
	# Queue.queue.append(Event.lambda().initialise(utilities.lambda_update_monitor_messages, [question, lID[lTags.lMonitor]]))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_update_monitor_messages, [question]))
	Queue.queue.append(Event.wait().initialise(1))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
	Queue.queue.append(Event.message_box().initialise(["That's quite a question."]))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
	Queue.queue.append(Event.message_box().initialise(["So contestant, what will be{newline}your answer ?"]))
	Queue.queue.append(Event.wait().initialise(0.25))
	
		
	if autoplay:
		Queue.queue.append(Event.wait().initialise(1.00))
		Queue.queue.append(Event.add_node().initialise("res://games/knews/nodes/autoplay/autoplay_quiz_answer.tscn", [], _constants.lID[_constants.lTags.AutoPlayer]))

	utilities.display_question_and_options(_constants.lCharacters.Presenter, "Select the correct answer:", ["1920 AD", "20 AD", "1 AD", "200 BC"])
	
	
	
	Queue.queue.append(Event.wait().initialise(1))
	Queue.add(Event.lambda().initialise(utilities.lambda_play_monitor_animation, ["Exit"]))
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_update_monitor_messages, [" "]))

	Queue.queue.append(Event.message_box().initialise(["That does it for the this{newline}round."]))
	Queue.queue.append(Event.message_box().initialise(["Let's go to the next one !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(_constants.lCharacters.Presenter, "Idle"))
	Queue.add(Event.wait().initialise(1))
	
func introduce_the_quiz_show():
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.add_node().initialise("res://games/knews/nodes/stage/node.quiz.stage.tscn", [], _constants.lID[_constants.lTags.Stage]))
	utilities.setup_monitor()
	Queue.queue.append(Event.fade_in().initialise())
	
	if not _constants.DEBUG:
		Queue.queue.append(Event.play_event_queue().initialise(_constants.lTags.presenter_introduction))
	else:
		pass

	add_contestant_portraits()
	Queue.queue.append(Event.wait().initialise(1))
	
	if _constants.DEBUG:
		pass
	contestant_introductions()
	Queue.queue.append(Event.label().initialise("Start Question"))
	Queue.queue.append(Event.wait().initialise(1))
	
	
	Queue.queue.append(Event.message_box().initialise(["Is everyone ready ?"]))
	common_events_1.player_message("This game is great, Crash.{SFX,res://assets/games/knews/neocortex/yes.wav}") # , OS.get_unique_id(), 2)
	Queue.queue.append(Event.message_box().initialise(["Bring the board in !"]))
	
	# TODO: Fix lambda interrupting quit_game, waiting for input ?
	# TODO: Update RunEverythingReference game
	present_next_question("When did Rome fall ?", ["1920 AD", "20 AD", "1 AD", "200 BC"])

	if _constants.ENABLE_LOOP:
		Queue.queue.append(Event.reset_variables().initialise())
		Queue.queue.append(Event.jump_to_label().initialise("Start Question"))
	else:
		Queue.queue.append(Event.lambda().initialise(utilities.erase_monitor_message, []))
		Queue.queue.append(Event.quit_game().initialise())


func initialise_global_queue():
	utilities.load_and_generate_assets(_constants.DEBUG, _constants.PRESENTER_INTRODUCTION)
	introduce_the_quiz_show()

func _comments_and_todos():
	# Sprite Order: # Background # Contestants 10 # Panels 20 # Hud 100
	# TODO: Add contestants as portraits + pallets [DONE]
	# TODO: Add idle "Breathing" animation to contestants [DONE]
	# TODO: Add sounds effects to contestant pallets (talking SEs)
	# TODO: Make first playable VAIN of quiz
	pass
