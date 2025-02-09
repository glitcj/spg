extends EventQueue

# Common tags/names

# TODO: Add script to include all variable defs and uuids, read by local scenes and utils
# TODO: Add 10 formatted questions / answers
# TODO: Fix scene tree, with Scene node as parent of all non global nodes
# TODO: Add neo cortex sound effects


# TODO: Replace Variables "active_scenes" with .global and lTags
# TODO: Add Variables.local for local scenes, and .global for global scene settings and mechanics etc
# TODO: Fix setup_monitor IDs passing, pass all lID and lNodes

# TODO: Add game local "global" Variables UUIDs script, this should 
# be loaded as a huge dictionary with all the variables used by
# the game, regardless of how long it is.


# TODO: Include uuid in message_box_settings and refactor all events
# TODO: Finish Presenter and Guest sprites
# TODO: Add 3D cortex player to viewport who streams the game
# TODO: This is a self playing game that produces a 247 stream to watch
# TODO: Ultimately this will evolve into a Self Playing Horror stream
# TODO: Game is a simple freddies
# TODO: Game can have interventions (down the link, e.g., player switches the freddie screen)


# TODO: Add stage in a viewport ?
# TODO: Add loop
# TODO: Add O / X in monitor images
# TODO: Add API auto loop
# TODO: Stream with API


# TODO: Fix detached message boxes event
# TODO: Finish _parse_popped_message()
# TODO: Add to CharacterBlueprint: WAIT characters + IMAGE characters + SOUND characters
# TODO: Replace remaining with local tags
# TODO: Finish contestant Presenter/A/B animated pixel sprites
# TODO: Refactor Variables, remove .global and replace with something better
# TODO: Add sound effects, music + O / X + character voices
# TODO: Add framed sprites with fixed dimensions
# TODO: Add sound effects
# TODO: Replace Variables strings/keys with ints, pulled from the enum Scene.Tags
# TODO: Add CommonGameEvents class and load all utilities into it
enum lTags {presenter_introduction, presenter, scene,  Stage, Presenter, Contestant_A, Contestant_B, Contestant_C, lMonitor, lMonitorAnimator, AutoPlayer}

enum lCharacters {A, B, Presenter, lMonitor, lStage}



# var SCENE = "SCENE"
var PRESENTER_INTRODUCTION = "PRESENTER_INTRODUCTION"
var PRESENTER = "PRESENTER"
var STAGE = "STAGE"

var Contestant_A = "Contestant_A"
var Contestant_B = "Contestant_B"
var Presenter = "Presenter"

var lPortraits = {
	lCharacters.A: "res://games/knews/portraits/pallet.contestant.A.animated.tscn",
	lCharacters.B: "res://games/knews/portraits/pallet.contestant.A.animated.tscn",
	lCharacters.Presenter: "res://games/knews/portraits/pallet.presenter.animated.tscn"
	
	}
	
var lID = {
	lTags.Stage: Variables.generate_uuid(), lTags.AutoPlayer: Variables.generate_uuid(), 
	lTags.lMonitor: "monitor_%s" % Variables.generate_uuid(), 
	lTags.lMonitorAnimator: "monitor_animator_%s" % Variables.generate_uuid()
	}

var lPositions = {
	lCharacters.A: Vector2(182, -120),
	lCharacters.B: Vector2(192, -120),
	lCharacters.Presenter: Vector2(-182, -120), # Vector2(0, -15),
	}

var DEBUG = true
var ENABLE_LOOP = true

# var utilities = preload("res://games/knews/scenes/utilities.knews.gd")
var common_events_1 = preload("res://games/knews/scenes/common.knews.gd")



# var utilities_as_a_class: _Knews_Utilities_2 = _Knews_Utilities_2.new(lID, lTags)
var utilities: _Knews_Utilities_2 = _Knews_Utilities_2.new(lID, lTags)


func add_contestant_portraits():
	common_events_1.add_contestant(lCharacters.Presenter, lPortraits[lCharacters.Presenter], lPositions[lCharacters.Presenter])
	Queue.queue.append(Event.message_box().initialise(["Ladies and gentlemen.{newline}{newline}{newline}               {image,res://assets/images/default.png}", "Welcome to the Knews.", "Let's welcome our guest{newline}to the stage."]))
	common_events_1.add_contestant(lCharacters.A, lPortraits[lCharacters.A], lPositions[lCharacters.A])
	
func contestant_introductions():
	# Contestant A
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.Presenter, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Our guest today is{newline}Alexander Bones.", "Introduce yourself !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Globalists are taking over.", "But.."]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["We will NOT, FALTER !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Laugh", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Idle", false))
	Queue.queue.append(Event.wait().initialise(2))


func present_next_question(question: String, answers: Array, autoplay: bool = true):
	Queue.queue.append(Event.wait().initialise(0.5))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
	# Queue.queue.append(Event.lambda().initialise(utilities.lambda_play_monitor_animation, [lID, lTags, "Enter"]))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_play_monitor_animation, ["Enter"]))
	Queue.queue.append(Event.wait().initialise(0.5))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
	Queue.queue.append(Event.message_box().initialise(["And the next question is:"]))
	# Queue.queue.append(Event.lambda().initialise(common_events_1.lambda_debug_break, []))
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
		Queue.queue.append(Event.add_node().initialise("res://games/knews/nodes/autoplay/autoplay_quiz_answer.tscn", [], lID[lTags.AutoPlayer]))
		# Queue.queue.append(Event.lambda().initialise(autoplay_quiz, []))

	# Queue.queue.append(Event.lambda().initialise(autoplay_quiz, []))
	# utilities.display_question_and_options(lCharacters.Presenter, "Select the correct answer:", ["1920 AD", "20 AD", "1 AD", "200 BC"], lTags, lID)
	utilities.display_question_and_options(lCharacters.Presenter, "Select the correct answer:", ["1920 AD", "20 AD", "1 AD", "200 BC"])
	
	
	
	Queue.queue.append(Event.wait().initialise(1))
	Queue.add(Event.lambda().initialise(utilities.lambda_play_monitor_animation, [lID, lTags, "Exit"]))
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_update_monitor_messages, [" ", lID[lTags.lMonitor]]))

	Queue.queue.append(Event.message_box().initialise(["That does it for the this{newline}round."]))
	Queue.queue.append(Event.message_box().initialise(["Let's go to the next one !"]))
	Queue.add(Event.wait().initialise(1))
	
func introduce_the_quiz_show():
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.add_node().initialise("res://games/knews/nodes/stage/node.quiz.stage.tscn", [], lID[lTags.Stage]))
	# utilities.setup_monitor(lTags, lID)
	utilities.setup_monitor()
	
	Queue.queue.append(Event.fade_in().initialise())
	
	if not DEBUG:
		Queue.queue.append(Event.play_event_queue().initialise(lTags.presenter_introduction))
	else:
		pass

	add_contestant_portraits()
	Queue.queue.append(Event.wait().initialise(1))
	
	if DEBUG:
		pass
	contestant_introductions()
	Queue.queue.append(Event.label().initialise("Start Question"))
	
	Queue.queue.append(Event.wait().initialise(1))
	
	
	Queue.queue.append(Event.message_box().initialise(["Is everyone ready ?"]))
	Queue.queue.append(Event.wait().initialise(1))
	common_events_1.player_message("This game is great, Crash.{SFX,res://assets/games/knews/neocortex/yes.wav}") # , OS.get_unique_id(), 2)
	Queue.queue.append(Event.message_box().initialise(["Bring the board in !"]))
	
	# TODO: Fix lambda interrupting quit_game, waiting for input ?
	# TODO: Update RunEverythingReference game
	present_next_question("When did Rome fall ?", ["1920 AD", "20 AD", "1 AD", "200 BC"])

	
	if ENABLE_LOOP:
		Queue.queue.append(Event.reset_variables().initialise())
		Queue.queue.append(Event.jump_to_label().initialise("Start Question"))
	else:
		Queue.queue.append(Event.lambda().initialise(utilities.erase_monitor_message, [lID, lTags]))
		Queue.queue.append(Event.quit_game().initialise())


func initialise_global_queue():
	utilities.load_and_generate_assets(DEBUG, PRESENTER_INTRODUCTION)
	introduce_the_quiz_show()

func _comments_and_todos():
	# Sprite Order: # Background # Contestants 10 # Panels 20 # Hud 100
	# TODO: Add contestants as portraits + pallets [DONE]
	# TODO: Add idle "Breathing" animation to contestants [DONE]
	# TODO: Add sounds effects to contestant pallets (talking SEs)
	# TODO: Make first playable VAIN of quiz
	pass
